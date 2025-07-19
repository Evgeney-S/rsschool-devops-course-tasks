pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "evgeneys/flask-app:latest"
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Build') {
            steps {
                dir('flask-app') {
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Unit Test') {
            steps {
                dir('flask-app') {
                    sh 'python -m unittest test_main.py'
                }
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONARQUBE_ENV = 'SonarQube'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=flask-app -Dsonar.sources=flask-app'
                }
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}").push()
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'helm upgrade --install flask-app helm/flask-app --set image.repository=evgeneys/flask-app --set image.tag=latest'
            }
        }

        stage('App Verification') {
            steps {
                sh 'curl --fail http://flask-app.default.svc.cluster.local:5000/health'
            }
        }
    }

    post {
        success {
            mail to: 'your-email@example.com',
                 subject: 'Pipeline Succeeded',
                 body: "Pipeline for flask-app passed successfully"
        }
        failure {
            mail to: 'your-email@example.com',
                 subject: 'Pipeline Failed',
                 body: "Pipeline for flask-app failed"
        }
    }
}
