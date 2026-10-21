pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Source code is checked out from GitHub.'
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Validate Project') {
            steps {
                sh '''
                    test -f app/Dockerfile
                    test -f app/index.html
                    test -f green/Dockerfile
                    test -f green/index.html
                    test -f k8s/blue-deployment.yaml
                    test -f k8s/green-deployment.yaml
                    test -f k8s/service.yaml
                    echo "Project file validation passed."
                '''
            }
        }

        stage('Check Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Check Kubernetes') {
            steps {
                sh '''
                    export KUBECONFIG=/home/ubuntu/.kube/config
                    kubectl get nodes
                    kubectl get deployments
                    kubectl get service vle8-service
                '''
            }
        }

        stage('Blue-Green Verification') {
            steps {
                sh '''
                    export KUBECONFIG=/home/ubuntu/.kube/config
                    kubectl rollout status deployment/blue-deployment --timeout=120s
                    kubectl rollout status deployment/green-deployment --timeout=120s
                    kubectl get pods -o wide
                    echo "Both Blue and Green deployments are available."
                '''
            }
        }
    }

    post {
        success {
            echo 'VLE-8 pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the Console Output.'
        }
    }
}
