pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kyipyar/calculator:1.0"
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
                 sh 'mvn -B clean compile'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'docker login -u $USER -p $PASS'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
				sh 'kubectl apply -f k8s/hazelcast.yaml'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}