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

        stage("Compile") {
            steps {
                sh "mvn compile"
            }
        }

        stage("Unit Test") {
            steps {
                sh "mvn test"
            }
        }

        stage("Build") {
            steps {
                 sh script: "mvn clean package -DskipTests", returnStatus: false
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${BUILD_TAG_VERSION} .
                """
            }
        }

        stage("Docker Push") {
            steps {
               sh """
                    docker rm -f calculator || true
                    docker run --name calculator -d -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}
                    """

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
