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
                git 'https://github.com/AyeKyiPyar/calculator.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -Dspring.profiles.active=test -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/hazelcast-deployment.yaml'
                sh 'kubectl apply -f k8s/hazelcast-service.yaml'

                sh 'kubectl rollout status deployment/hazelcast'

                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}