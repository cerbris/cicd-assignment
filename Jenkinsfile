pipeline {
    agent any

    environment {
        WEBEX_WEBHOOK_URL = credentials('webex-webhook-url')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                echo 'Setting up Python environment...'
                sh '''
                    python3 --version
                    pip3 --version
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh '''
                    python3 -m pytest test_app.py -v --tb=short || python3 -m unittest test_app.py -v
                '''
            }
        }

        stage('Run Application') {
            steps {
                echo 'Running the application...'
                sh 'python3 app.py'
            }
        }
    }

    post {
        success {
            echo 'Build succeeded! Sending notification to WebEx...'
            script {
                sendWebExNotification('SUCCESS')
            }
        }
        failure {
            echo 'Build failed! Sending notification to WebEx...'
            script {
                sendWebExNotification('FAILURE')
            }
        }
        always {
            echo 'Pipeline execution completed.'
        }
    }
}

def sendWebExNotification(String status) {
    def color = status == 'SUCCESS' ? 'Good' : 'Danger'
    def emoji = status == 'SUCCESS' ? '✅' : '❌'

    def message = """
${emoji} **Jenkins Build ${status}**

**Job:** ${env.JOB_NAME}
**Build Number:** ${env.BUILD_NUMBER}
**Status:** ${status}
**Branch:** ${env.GIT_BRANCH ?: 'N/A'}
**Commit:** ${env.GIT_COMMIT?.take(7) ?: 'N/A'}
**Build URL:** ${env.BUILD_URL}
**Timestamp:** ${new Date().format('yyyy-MM-dd HH:mm:ss')}
    """.trim()

    sh """
        curl -X POST ${WEBEX_WEBHOOK_URL} \
        -H 'Content-Type: application/json' \
        -d '{
            "markdown": "${message.replaceAll('"', '\\\\"').replaceAll('\n', '\\\\n')}"
        }'
    """
}
