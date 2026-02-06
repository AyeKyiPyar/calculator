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
        CONTAINER_NAME = "calculator-container"
        BUILD_TAG_VERSION = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
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
                sh "mvn test"
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('JaCoCo Report') {
            steps {
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

        stage("Build Jar") {
            steps {
                sh "mvn package -DskipTests"
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                docker build --no-cache -t ${IMAGE_NAME}:${BUILD_TAG_VERSION} .
                """
            }
        }

       stage("Docker Deploy") {
            steps {
                sh '''
                if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
                    echo "Stopping existing container ${CONTAINER_NAME}"
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                else
                    echo "No existing container found"
                fi
        
                docker run -d --name ${CONTAINER_NAME} -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}
                '''
            }
        }

    }

    post {
        success {
            echo "✅ Maven CI/CD Pipeline completed successfully"
        }
        failure {
            echo "❌ Maven CI/CD Pipeline failed"
        }
    }
}
