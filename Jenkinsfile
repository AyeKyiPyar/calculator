// pipeline {
//     agent any

//     triggers {
//         pollSCM('* * * * *')
//     }

//     tools {
//         maven 'maven3.9'
//         jdk 'jdk21'
//     }

//     environment {
//         IMAGE_NAME = "calculator"
//         CONTAINER_NAME = "calculator-container"
//         BUILD_TAG_VERSION = "${BUILD_NUMBER}"
//     }

//     stages {

//         stage('Checkout') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/AyeKyiPyar/calculator.git'
//             }
//         }

//         stage("Compile") {
//             steps {
//                 sh "mvn compile"
//             }
//         }
        
//         stage("Unit Test") {
//             steps {
//                 script {
//                     // Run tests but don't fail the build immediately
//                     def testStatus = sh(script: "mvn test", returnStatus: true)
//                     junit 'target/surefire-reports/*.xml'
                    
//                     if (testStatus != 0) {
//                         echo "⚠️ Some tests failed, but continuing with the pipeline"
//                     }
//                 }
//             }
//         }
        
//         stage('JaCoCo Report') {
//             steps {
//                 script {
//                     if (fileExists('target/site/jacoco/index.html')) {
//                         publishHTML([
//                             allowMissing: false,
//                             alwaysLinkToLastBuild: true,
//                             keepAll: true,
//                             reportDir: 'target/site/jacoco',
//                             reportFiles: 'index.html',
//                             reportName: 'JaCoCo Coverage'
//                         ])
//                     } else {
//                         echo "⚠️ JaCoCo report not found, skipping..."
//                     }
//                 }
//             }
//         }


//         stage("Static Code Analysis (Checkstyle)") {
//             steps {
//                 script {
//                     def checkStatus = sh(script: "mvn checkstyle:checkstyle", returnStatus: true)
//                     publishHTML(target: [
//                         reportDir: 'target/site',
//                         reportFiles: 'checkstyle.html',
//                         reportName: 'Checkstyle Report'
//                     ])
//                     if (checkStatus != 0) {
//                         echo "⚠️ Checkstyle warnings found, but continuing..."
//                     }
//                 }
//             }
//         }

//         stage("Build Jar") {
//             steps {
//                 sh "mvn package -DskipTests"
//             }
//         }

//         stage("Docker Build") {
//             steps {
//                 sh "docker build --no-cache -t ${IMAGE_NAME}:${BUILD_TAG_VERSION} ."
//             }
//         }
        
//         stage("Docker Deploy") {
//             steps {
//                 script {
//                     // Stop/remove existing container if it exists
//                     def containerExists = sh(script: "docker ps -aq -f name=${CONTAINER_NAME}", returnStdout: true).trim()
//                     if (containerExists) {
//                         sh "docker stop ${CONTAINER_NAME} || true"
//                         sh "docker rm ${CONTAINER_NAME} || true"
//                     }
//                     // Run new container safely
//                     def runStatus = sh(script: "docker run -d --name ${CONTAINER_NAME} -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}", returnStatus: true)
//                     if (runStatus != 0) {
//                         echo "⚠️ Docker run failed, check logs"
//                     } else {
//                         echo "✅ Docker container ${CONTAINER_NAME} deployed successfully"
//                     }
//                 }
//             }
//         }

//     }

//     // post {
//     //     success {
//     //         echo "✅ Maven CI/CD Pipeline completed successfully"
//     //     }
//     //     failure {
//     //         echo "❌ Maven CI/CD Pipeline failed"
//     //     }
//     // }

//    // post {
//    //      success {
//    //          emailext(
//    //              subject: "✅ Maven CI/CD Pipeline Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
//    //              body: """Hello Team,
    
//    //  The Maven CI/CD Pipeline has completed successfully.
    
//    //  Job: ${env.JOB_NAME}
//    //  Build Number: ${env.BUILD_NUMBER}
//    //  Build URL: ${env.BUILD_URL}
    
//    //  Best Regards,
//    //  Jenkins""",
//    //              to: "ayekyipyarshwe@gmail.com",
//    //              from: "ayekyipyarshwe@gmail.com",
//    //              mimeType: 'text/html'
//    //          )
//    //      }
//    //      failure {
//    //          emailext(
//    //              subject: "❌ Maven CI/CD Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
//    //              body: """Hello Team,
    
//    //  The Maven CI/CD Pipeline has failed.
    
//    //  Job: ${env.JOB_NAME}
//    //  Build Number: ${env.BUILD_NUMBER}
//    //  Build URL: ${env.BUILD_URL}
    
//    //  Please check the logs and fix the issue.
    
//    //  Best Regards,
//    //  Jenkins""",
//    //              to: "ayekyipyarshwe@gmail.com",
//    //              from: "ayekyipyarshwe@gmail.com",
//    //              mimeType: 'text/html'
//    //          )
//    //      }
//    //  }
//     post {
//         success {
//             emailext(
//                 to: 'ayekyipyarshwe@gmail.com',
//                 subject: '✅ Build SUCCESS',
//                 body: 'Build completed successfully.'
//             )
//         }
    
//         failure {
//             emailext(
//                 to: 'ayekyipyarshwe@gmail.com',
//                 subject: '❌ Build FAILED',
//                 body: 'Build failed. Check logs.'
//             )
//         }
//     }


// }

pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')   // every 5 minutes (safe)
    }

    tools {
        maven 'maven3.9'
        jdk 'jdk21'
    }

    environment {
        IMAGE_NAME = "akps-calculator"
        CONTAINER_NAME = "akps-calculator-container"
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
                script {
                    def testStatus = sh(script: "mvn test", returnStatus: true)
                    junit 'target/surefire-reports/*.xml'
                    
                    if (testStatus != 0) {
                        echo "⚠️ Some tests failed"
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }
        
        stage('JaCoCo Report') {
            steps {
                script {
                    if (fileExists('target/site/jacoco/index.html')) {
                        publishHTML([
                            allowMissing: false,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: 'target/site/jacoco',
                            reportFiles: 'index.html',
                            reportName: 'JaCoCo Coverage'
                        ])
                    } else {
                        echo "⚠️ JaCoCo report not found"
                    }
                }
            }
        }

        stage("Checkstyle") {
            steps {
                script {
                    def status = sh(script: "mvn checkstyle:checkstyle", returnStatus: true)

                    publishHTML(target: [
                        reportDir: 'target/site',
                        reportFiles: 'checkstyle.html',
                        reportName: 'Checkstyle Report'
                    ])

                    if (status != 0) {
                        echo "⚠️ Checkstyle issues found"
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }

        stage("Build Jar") {
            steps {
                sh "mvn package -DskipTests"
            }
        }

        // stage("Docker Login") {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
        //             sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        //         }
        //     }
        // }
        
        stage("Docker Build") {
            steps {
                sh "docker build --no-cache -t ${IMAGE_NAME}:${BUILD_TAG_VERSION} ."
            }
        }
        
        stage("Docker Push") {
            steps {
                sh "docker push ${IMAGE_NAME}:${BUILD_TAG_VERSION}"
            }
        }

        stage("Docker Deploy") {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -aq -f name=${CONTAINER_NAME}", returnStdout: true).trim()

                    if (containerExists) {
                        sh "docker stop ${CONTAINER_NAME} || true"
                        sh "docker rm ${CONTAINER_NAME} || true"
                    }

                    def runStatus = sh(script: "docker run -d --name ${CONTAINER_NAME} -p 8082:8080 ${IMAGE_NAME}:${BUILD_TAG_VERSION}", returnStatus: true)

                    if (runStatus != 0) {
                        echo "⚠️ Docker failed"
                        currentBuild.result = 'FAILURE'
                    } else {
                        echo "✅ Container deployed"
                    }
                }
            }
        }
        // stage("Acceptance test") {
        //         steps {
        //         sleep 60
        //         sh "chmod +x acceptance_test.sh && ./acceptance_test.sh"
        //         }
        // }
    }

    post {
        // always {
        //     emailext(
        //         to: 'ayekyipyarshwe@gmail.com',
        //         subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        //         body: """
        //                 Build Status: ${currentBuild.currentResult}
                        
        //                 Job: ${env.JOB_NAME}
        //                 Build: ${env.BUILD_NUMBER}
        //                 URL: ${env.BUILD_URL}
        //                 """,
        //         mimeType: 'text/plain'
        //     )
        // }
        success {
            echo "✅ Maven CI/CD Pipeline completed successfully"
        }
        failure {
            echo "❌ Maven CI/CD Pipeline failed"
        }
    }
}

