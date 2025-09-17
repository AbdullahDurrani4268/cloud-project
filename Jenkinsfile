pipeline {
    agent {
        docker {
            image 'docker:24.0'   // Docker client image
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        REGISTRY = "us.icr.io/durrani"
        IMAGE = "node-app"
        KUBECONFIG_CRED = 'kubeconfig'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/AbdullahDurrani4268/cloud-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $REGISTRY/$IMAGE:${BUILD_NUMBER} ."
            }
        }

        stage('Push Image to ICR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'icr-credentials', usernameVariable: 'ICR_USER', passwordVariable: 'ICR_PASSWORD')]) {
                    sh """
                      echo $ICR_PASSWORD | docker login -u $ICR_USER --password-stdin us.icr.io
                      docker push $REGISTRY/$IMAGE:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CRED}", variable: 'KUBECONFIG')]) {
                    sh """
                      kubectl --kubeconfig=$KUBECONFIG -n dev set image deployment/node-app node-app=$REGISTRY/$IMAGE:${BUILD_NUMBER}
                      kubectl --kubeconfig=$KUBECONFIG -n dev rollout status deployment/node-app
                    """
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Deploy to Production?'
            }
        }

        stage('Deploy to Prod') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CRED}", variable: 'KUBECONFIG')]) {
                    sh """
                      kubectl --kubeconfig=$KUBECONFIG -n prod set image deployment/node-app node-app=$REGISTRY/$IMAGE:${BUILD_NUMBER}
                      kubectl --kubeconfig=$KUBECONFIG -n prod rollout status deployment/node-app
                    """
                }
            }
        }
    }
}
