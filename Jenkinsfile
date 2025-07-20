podTemplate(containers: [
    containerTemplate(name: 'python', image: 'python:3.10', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'docker', image: 'gcr.io/kaniko-project/executor:latest', command: 'sleep', args: '99d', ttyEnabled: true)
]) {
    node(POD_LABEL) {
        stage('Test Python') {
            container('python') {
                sh 'python3 --version'
            }
        }
        stage('Test Docker/kaniko') {
            container('docker') {
                sh '/kaniko/executor --version || true'
            }
        }
    }
}
