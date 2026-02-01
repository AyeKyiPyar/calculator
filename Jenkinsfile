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

        stage("Code Coverage (JaCoCo)") {
            steps {
                sh "mvn jacoco:report"
                publishHTML(target: [
                    reportDir: 'target/site/jacoco',
                    reportFiles: 'index.html',
                    reportName: 'JaCoCo Report'
                ])
                sh "mvn jacoco:check"
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

        stage("Build") {
            steps {
                sh "mvn clean package -DskipTests"
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
                sh "docker push ${IMAGE_NAME}:${BUILD_TAG_VERSION}"
            }
        }

        stage("Deploy to Staging") {
            steps {
                sh "ansible-playbook playbook.yml -i inventory/staging"
                sleep 60
            }
        }

        stage("Acceptance Test") {
            steps {
                sh "./acceptance_test.sh 192.168.0.18"
            }
        }

        stage("Release to Production") {
            steps {
                sh "ansible-playbook playbook.yml -i inventory/production"
                sleep 60
            }
        }

        stage("Smoke Test") {
            steps {
                sh "./smoke_test.sh 192.168.0.18"
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
