pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: env
    image: evgeneys/flask-app-build-env:latest
    command:
    - cat
    tty: true
"""
            defaultContainer 'env'
        }
    }

    parameters {
        booleanParam(name: 'RUN_DOCKER_BUILD', defaultValue: false, description: 'Build Docker image')
        booleanParam(name: 'RUN_DOCKER_PUSH', defaultValue: false, description: 'Push Docker image to Docker Hub')
    }

    environment {
        DOCKER_IMAGE = "evgeneys/flask-app:latest"
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
        SONARQUBE_ENV = 'SonarQube'
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Install dependencies') {
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

        // stage('SonarQube Analysis') {
        //     steps {
        //         withSonarQubeEnv('SonarQube') {
        //             sh 'sonar-scanner -Dsonar.projectKey=flask-app -Dsonar.sources=flask-app'
        //         }
        //     }
        // }

        stage('Docker Build') {
            when {
                expression { return params.RUN_DOCKER_BUILD }
            }
            steps {
                container('env') {
                    sh 'docker build -t ${DOCKER_IMAGE} flask-app'
                }
            }
        }

        stage('Push to Docker Hub') {
            when {
                expression { return params.RUN_DOCKER_PUSH }
            }
            steps {
                container('env') {
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push ${DOCKER_IMAGE}
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('env') {
                    sh 'helm upgrade --install flask-app helm/flask-app --set image.repository=evgeneys/flask-app --set image.tag=latest'
                }
            }
        }

        stage('App Verification') {
            steps {
                container('env') {
                    sh 'curl --fail http://flask-app.default.svc.cluster.local:5000/health'
                }
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
