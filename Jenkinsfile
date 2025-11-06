// pipeline {
//     agent any

//     environment {
//         IMAGE_NAME = "hello-devops"
//         CONTAINER_NAME = "hello-devops-container"
//         PORT = "3000"
//     }

//     stages {

//         stage('Checkout') {
//             steps {
//                 echo "Fetching latest code from GitHub..."
//                 checkout scm
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 echo "Building Docker image..."
//                 script {
//                     sh 'docker build -t ${IMAGE_NAME} .'
//                 }
//             }
//         }

//         stage('Run Container') {
//             steps {
//                 echo "Running Docker container..."
//                 script {
//                     // stop and remove any old container
//                     sh '''
//                         docker rm -f ${CONTAINER_NAME} || true
//                         docker run -d -p ${PORT}:3000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
//                     '''
//                 }
//             }
//         }

//         stage('Verify Container') {
//             steps {
//                 echo "Checking if app is running..."
//                 script {
//                     sh "docker ps | grep ${CONTAINER_NAME}"
//                 }
//             }
//         }
//     }

//     post {
//         success {
//             echo "✅ Build and container deployment successful!"
//         }
//         failure {
//             echo "❌ Build failed. Check logs."
//         }
//     }
// }



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

        stage('Security Scan with Trivy') {
            steps {
                echo "Running Trivy security scan..."
                script {
                    // Create reports folder if not exists
                    sh '''
                        mkdir -p reports
                        trivy image --severity HIGH,CRITICAL --format table -o reports/trivy-report.txt ${IMAGE_NAME} || true
                    '''
                    echo "Trivy scan completed. Report saved to 'reports/trivy-report.txt'"
                }
            }
        }

        stage('Run Container') {
            steps {
                echo "Running Docker container..."
                script {
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
        always {
            archiveArtifacts artifacts: 'reports/*.txt', allowEmptyArchive: true
        }
        success {
            echo "✅ Build, scan, and deploy successful!"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
