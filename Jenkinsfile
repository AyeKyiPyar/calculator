pipeline {
    agent any

    environment {
        IMAGE = "kyipyar/calculator:1.0"
    }
    
     tools {
        maven 'maven3.9'
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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

      stage('Push to Docker Hub') {
		    steps {
		        withCredentials([usernamePassword(
		            credentialsId: 'dockerhub',
		            usernameVariable: 'USER',
		            passwordVariable: 'PASS'
		        )]) {
		            sh 'docker login -u $USER -p $PASS'
		            sh 'docker push kyipyar/calculator:1.0'
		        }
		    }
		}
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f hazelcast.yaml --validate=false'

                sh 'kubectl rollout status deployment/hazelcast'

                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}