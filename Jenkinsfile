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
        SONAR_URL = "http://sonar:9000"
        SONAR_TOKEN = credentials('auth-token')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AyeKyiPyar/calculator.git'
            }
        }

        stage('Compile') {
            steps {
                retry(2) {
                    sh 'mvn -B clean compile'
                }
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

        stage('Checkstyle') {
            steps {
                script {
                    def status = sh(script: "mvn checkstyle:checkstyle", returnStatus: true)

                    publishHTML(target: [
                        reportDir: 'target/site',
                        reportFiles: 'checkstyle.html',
                        reportName: 'Checkstyle Report'
                    ])

                    if (status != 0)
                        unstable("Checkstyle issues found")
                }
            }
        }

        stage('Coverage Report') {
            steps {
                sh 'mvn jacoco:report'

                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target/site/jacoco',
                    reportFiles: 'index.html',
                    reportName: 'Coverage Report'
                ])
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def status = sh(
                        script: """
                            mvn sonar:sonar \
                            -Dsonar.host.url=${env.SONAR_URL} \
                            -Dsonar.login=${env.SONAR_TOKEN} \
                            -Dsonar.projectKey=akps-calculator \
                            -Dsonar.projectName=akps-calculator \
                            -Dsonar.sources=src/main/java
                        """,
                        returnStatus: true
                    )

                    if (status != 0)
                        unstable("SonarQube analysis failed")
                }
            }
        }

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
                --cache-from ${IMAGE_NAME}:latest \
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

       stage('Acceptance Test') {
    steps {
         sh 'chmod +x acceptance_test.sh'
        sh './acceptance_test.sh 192.168.1.4'
    }
}
    }

    post {
        success {
            echo "✅ PIPELINE SUCCESS"
            emailext(
                to: 'ayekyipyarshwe@gmail.com',
                subject: '✅ Build SUCCESS',
                body: 'Build completed successfully.'
            )
        }

        

        failure {
            echo "❌ PIPELINE FAILED"
        }

        
    }
}
