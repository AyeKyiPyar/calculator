pipeline {
    agent any

    environment {
        IMAGE = "kyipyar/calculator:1.0"
        

        DEV_CONTEXT  = "kind-calculator-dev"
        PROD_CONTEXT = "kind-calculator-prod"
    }

    tools {
        maven 'maven3.9'
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AyeKyiPyar/calculator.git'
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

       
        stage('Build Docker Image') {
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
		
	/*	stage('Deploy to Dev') {
		    steps {
		        // This block extracts the secret and sets the $KUBECONFIG environment variable automatically
		        withKubeConfig([credentialsId: 'kubeconfig-dev']) {
		            
		            // Explicitly force kubectl to use the file Jenkins just extracted
		            sh 'kubectl apply -f deployment-dev.yaml --validate=false'
		        }
		    }
		}*/
		stage('Deploy to DEV') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig-dev',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
					kubectl config use-context kind-calculator-dev
                    kubectl config current-context
            		kubectl apply -f deployment-dev.yaml --server=https://calculator-dev-control-plane:6443 --insecure-skip-tls-verify=true
                   	kubectl apply -f service.yaml --validate=false --insecure-skip-tls-verify=true
                    '''
                }
            }
        }

        stage('Approval') {
            steps {
                input "Deploy to Production?"
            }
        }

        stage('Deploy to PROD') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig-prod',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
                    kubectl apply -f deployment-prod.yaml --validate=false --insecure-skip-tls-verify=true
                    kubectl apply -f service.yaml --validate=false --insecure-skip-tls-verify=true
                    '''
                }
            }
        }
		
       /* stage('Deploy with Ansible') {
            steps {
                  withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        ansible-playbook ansible/deploy.yaml -i ansible/inventory
                    '''
                }
            }
        }*/
    

        /*stage('Deploy to DEV Cluster') {
		    steps {
		
		        withCredentials([
		            file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
		        ]) {
		
		            sh '''
		            kubectl config get-contexts
		
		            kubectl config use-context kind-calculator-dev
		
		            kubectl cluster-info
		
		            kubectl get nodes
		
		            kubectl apply -f deployment.yaml --validate=false
		
		            kubectl apply -f service.yaml --validate=false
		
		            kubectl rollout status deployment/calculator
		            '''
		        }
		    }
		}

        stage('DEV Validation Test') {
            steps {

                withCredentials([file(
                    credentialsId: 'kubeconfig',
                    variable: 'KUBECONFIG'
                )]) {

                    sh """
                    kubectl config use-context ${DEV_CONTEXT}

                    kubectl get nodes
                    kubectl get pods
                    kubectl get svc
                    """
                }
            }
        }

        stage('Deploy to PROD Cluster') {
            steps {

                withCredentials([file(
                    credentialsId: 'kubeconfig',
                    variable: 'KUBECONFIG'
                )]) {

                    sh """
                    kubectl config use-context ${PROD_CONTEXT}

                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml

                    kubectl set image deployment/calculator \
                    calculator=${IMAGE_NAME}:${IMAGE_TAG}

                    kubectl rollout status deployment/calculator
                    """
                }
            }
        }

        stage('PROD Validation Test') {
            steps {

                withCredentials([file(
                    credentialsId: 'kubeconfig',
                    variable: 'KUBECONFIG'
                )]) {

                    sh """
                    kubectl config use-context ${PROD_CONTEXT}

                    kubectl get nodes
                    kubectl get pods
                    kubectl get svc
                    """
                }
            }
        }*/
    }

    post {

        success {
            echo 'CI/CD Pipeline Completed Successfully!'
        }

        failure {
            echo 'Pipeline Failed!'
        }
    }
}
