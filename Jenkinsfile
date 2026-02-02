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

        stage("Unit Test + Coverage") {
            steps {
                // Run tests and generate JaCoCo report in one step
                sh "mvn clean verify"
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
                docker run --name ${IMAGE_NAME} -d -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}
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
