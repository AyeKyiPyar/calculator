pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }

    tools {
        maven 'maven3.9'
        jdk 'jdk21'
    }

    environment {
        IMAGE_NAME = "calculator"
        BUILD_TAG_VERSION = "${BUILD_NUMBER}"
    }

    stages {
        
        stage('Checkout') {
            steps {
                // Pull code from Git
                git branch: 'main', url: 'https://github.com/AyeKyiPyar/calculator.git'
            }
        }

        stage("Compile") {
            steps {
                sh "mvn compile"
            }
        }

          stage("Unit Test") {
            steps {
                // Run unit tests and collect results for Jenkins
                sh "mvn test"
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('JaCoCo Report') {
            steps {
                // Publish JaCoCo HTML report in Jenkins
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target/site/jacoco',
                    reportFiles: 'index.html',
                    reportName: 'JaCoCo Coverage'
                ])
            }
        }
        stage("Static Code Analysis (Checkstyle)") {
            steps {
                sh "mvn checkstyle:checkstyle"
                publishHTML(target: [
                    reportDir: 'target/site',
                    reportFiles: 'checkstyle.html',
                    reportName: 'Checkstyle Report'
                ])
            }
        }
         stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                      mvn sonar:sonar \
                      -Dsonar.projectKey=${SONAR_PROJECT_KEY}
                    """
                }
            }
        }
        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
        stage("Build Jar") {
            steps {
                // Package without cleaning to avoid deleting reports
                sh "mvn package -DskipTests"
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${BUILD_TAG_VERSION} .
                """
            }
        }

        stage("Docker Deploy") {
            steps {
                // Stop old container if exists, then run new one
                sh """
                docker rm -f ${IMAGE_NAME} || true
                docker run --name ${IMAGE_NAME} --network mynet -d -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Maven CI/CD Pipeline completed successfully"
            // mail to: 'ayekyipyarshwe@gmail.com',
            //  subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            //  body: "Build succeeded.\n\nURL: ${env.BUILD_URL}"
        }
        failure {
            echo "❌ Maven CI/CD Pipeline failed"
            // mail to: 'ayekyipyarshwe@gmail.com',
            //  subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            //  body: "Build failed.\n\nCheck logs: ${env.BUILD_URL}"
        }
    }
}
