pipeline {
    agent any

    environment {
        IMAGE_NAME = "hello-devops"
        CONTAINER_NAME = "hello-devops-container"
        PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Fetching latest code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Run Container') {
            steps {
                echo "Running Docker container..."
                script {
                    // stop and remove any old container
                    sh '''
                        docker rm -f ${CONTAINER_NAME} || true
                        docker run -d -p ${PORT}:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Verify Container') {
            steps {
                echo "Checking if app is running..."
                script {
                    sh "docker ps | grep ${CONTAINER_NAME}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and container deployment successful!"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
