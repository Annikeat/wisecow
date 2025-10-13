pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'aniketjok'
        IMAGE_NAME = "${DOCKERHUB_USER}/wisecow"
        DOCKERHUB_CRED = 'dockerhub-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Pulling latest code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: "$DOCKERHUB_CRED", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push $IMAGE_NAME:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Deploying container using Docker Compose..."
                sh '''
                  docker-compose down || true
                  docker-compose pull || true
                  docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs."
        }
    }
}

