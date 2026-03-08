pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    tools {
        maven 'maven3.9'
    }

    environment {
        IMAGE_NAME = "akps-calculator"
        CONTAINER_NAME = "akps-calculator-container"
        VERSION = "${BUILD_NUMBER}"
        SONAR_URL = "http://localhost:9000"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AyeKyiPyar/calculator.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn -B test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        // stage('Code Quality') {
        //     parallel {

        //         stage('Checkstyle') {
        //             steps {
        //                 sh 'mvn checkstyle:checkstyle'
        //             }
        //             post {
        //                 always {
        //                     publishHTML(target: [
        //                         allowMissing: true,
        //                         keepAll: true,
        //                         alwaysLinkToLastBuild: true,
        //                         reportDir: 'target/site',
        //                         reportFiles: 'checkstyle.html',
        //                         reportName: 'Checkstyle Report'
        //                     ])
        //                 }
        //             }
        //         }

        //         stage('Coverage') {
        //             steps {
        //                 sh 'mvn jacoco:report'
        //             }
        //             post {
        //                 always {
        //                     publishHTML(target: [
        //                         allowMissing: true,
        //                         keepAll: true,
        //                         alwaysLinkToLastBuild: true,
        //                         reportDir: 'target/site/jacoco',
        //                         reportFiles: 'index.html',
        //                         reportName: 'Coverage Report'
        //                     ])
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('SonarQube Analysis') {
        //     steps {
        //         withCredentials([string(credentialsId: 'auth-token', variable: 'SONAR_TOKEN')]) {
        //             sh """
        //                 mvn sonar:sonar \
        //                 -Dsonar.host.url=${SONAR_URL} \
        //                 -Dsonar.login=${SONAR_TOKEN} \
        //                 -Dsonar.projectKey=akps-calculator \
        //                 -Dsonar.projectName=akps-calculator \
        //                 -Dsonar.sources=src/main/java
        //             """
        //         }
        //     }
        // }

        stage('Package') {
            steps {
                sh 'mvn -B package -DskipTests'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build \
                    -t ${IMAGE_NAME}:${VERSION} \
                    -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 8082:8080 \
                        ${IMAGE_NAME}:${VERSION}
                """
            }
        }

        stage('Wait For App') {
            steps {
                sh '''
                    for i in {1..20}
                    do
                      curl -s http://localhost:8082 && break
                      echo "Waiting for app..."
                      sleep 3
                    done
                '''
            }
        }

        stage('Acceptance Test') {
		    steps {
		        // Run your acceptance test script
		        sh 'mvn verify -Pacceptance'
		    }
		    post {
		        always {
		            // JUnit XML reports (for test results)
		            junit allowEmptyResults: true, testResults: 'target/cucumber-reports/*.xml'
		
		            // HTML report from Cucumber
		            publishHTML(target: [
		                allowMissing: true,
		                keepAll: true,
		                alwaysLinkToLastBuild: true,
		                reportDir: 'target/cucumber-reports',      // folder where HTML is generated
		                reportFiles: 'cucumber-report.html',       // actual HTML file
		                reportName: 'Acceptance Report'
		            ])
		        }
		    }
		}
    }

    post {
        success {
            echo "✅ PIPELINE SUCCESS"
            emailext(
                to: 'ayekyipyarshwe@gmail.com',
                subject: "Build SUCCESS #${BUILD_NUMBER}",
                body: "Build #${BUILD_NUMBER} completed successfully."
            )
        }

        failure {
            echo "❌ PIPELINE FAILED"
            emailext(
                to: 'ayekyipyarshwe@gmail.com',
                subject: "Build FAILED #${BUILD_NUMBER}",
                body: "Build #${BUILD_NUMBER} failed. Please check Jenkins."
            )
        }

       
    }
}
