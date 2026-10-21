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
                    export KUBECONFIG=/var/lib/jenkins/.kube/config
                    kubectl get nodes
                    kubectl get deployments
                    kubectl get service vle8-service
                '''
            }
        }

        stage('Deploy Green') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config
                    kubectl rollout status deployment/green-deployment --timeout=120s
                    kubectl patch service vle8-service -p '{"spec":{"selector":{"app":"vle8","version":"green"}}}'
                    sleep 3
                    curl -fsS http://localhost:30080 | grep -i 'GREEN VERSION'
                    echo "Green deployment is now active."
                '''
            }
        }

        stage('Verify Green Deployment') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config
                    kubectl get service vle8-service
                    kubectl get deployments
                    kubectl get pods
                    echo "Blue and Green deployments remain available."
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
