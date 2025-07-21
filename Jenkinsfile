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
      volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
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
                echo '⏩ Application build (installing dependencies)'
                dir('flask-app') {
                    sh '''
                        pip install -r requirements.txt
                        echo "✅ Application build completed successfully (dependencies installed)!"
                    '''
                }
            }
        }

        stage('Unit Test') {
            steps {
                echo '⏩ Unit tests'
                dir('flask-app') {
                    sh '''
                        python -m unittest test_main.py
                        echo "✅ Unit tests passed successfully!"
                    '''
                }
            }
        }

        // stage('SonarQube Analysis') {
        //     steps {
        //         echo '⏩ Security check with SonarQube'
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
                echo '⏩ Docker image building'
                container('env') {
                    sh '''
                        // docker version
                        docker build -t ${DOCKER_IMAGE} flask-app
                        echo "✅ Docker image built successfully!"
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            when {
                expression { return params.RUN_DOCKER_PUSH }
            }
            steps {
                echo '⏩ Pushing Docker image to Docker Hub'
                container('env') {
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker push ${DOCKER_IMAGE}
                            echo "✅ Docker image pushed successfully!"
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '⏩ Deployment to the K8s cluster with Helm'
                container('env') {
                    sh '''
                        helm upgrade --install flask-app helm/flask-app \
                            --namespace jenkins \
                            --create-namespace \
                            --set image.repository=evgeneys/flask-app \
                            --set image.tag=latest
                        echo "✅ Deployment completed successfully!"
                    '''
                }
            }
        }

        stage('App Verification') {
            steps {
                echo '⏩ Application verification'
                container('env') {
                    sh '''
                        // curl --fail http://flask-app.jenkins.svc.cluster.local:5000/health
                        // STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://flask-app.jenkins.svc.cluster.local:5000/health)
                        RESPONSE=$(curl -s -w "___STATUS_CODE___%{http_code}" http://flask-app.jenkins.svc.cluster.local:5000/health)
                        echo "Response: $RESPONSE"
                        BODY=$(echo "$RESPONSE" | sed 's/___STATUS_CODE___.*//')
                        STATUS=$(echo "$RESPONSE" | sed 's/.*___STATUS_CODE___//')
                        if [ "$STATUS" -eq 200 ]; then
                            echo "✅ App Verification passed successfully!"
                            echo "📦 App response:"
                            echo "$BODY"
                        else
                            echo "❌ App Verification error. Status: $STATUS"
                            kubectl get pods -n jenkins
                            exit 1
                        fi
                    '''
                }
            }
        }

    }

    post {
        success {
        echo '✅ Pipeline successed'
        container('env') {
            withCredentials([
            string(credentialsId: 'TELEGRAM_BOT_TOKEN', variable: 'TG_BOT_TOKEN'),
            string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'TG_CHAT_ID')
            ]) {
            sh """
                curl -s -X POST https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage \
                -d parse_mode="HTML" \
                -d chat_id=$TG_CHAT_ID \
                -d text="✅ Jenkins pipeline succeeded: '$JOB_NAME' #$BUILD_NUMBER"
            """
            }
        }
        }

        failure {
        echo '❌ Pipeline failed'
        container('env') {
            withCredentials([
            string(credentialsId: 'TELEGRAM_BOT_TOKEN', variable: 'TG_BOT_TOKEN'),
            string(credentialsId: 'TELEGRAM_CHAT_ID', variable: 'TG_CHAT_ID')
            ]) {
            sh """
                curl -s -X POST https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage \
                -d parse_mode="HTML" \
                -d chat_id=$TG_CHAT_ID \
                -d text="❌ Jenkins pipeline failed: '$JOB_NAME' #$BUILD_NUMBER"
            """
            }
        }
        }
    }


}
