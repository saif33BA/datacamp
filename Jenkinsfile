pipeline {
    agent any
    tools { 
        jdk 'JDK17'
        maven 'Maven3'
    }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        DOCKER_TAG = ''
        DOCKER_CREDENTIALS = credentials('docker-credentials')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/saif33BA/datacamp.git'
            }
        }
        
        stage('Set Docker Tag') {
            steps {
                script {
                    DOCKER_TAG = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                sh 'docker build -t saif33BA/image_name:${DOCKER_TAG} .'
            }
        }
        
        stage('DockerHub Push') {
            steps {
                sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin'
                sh 'docker push saif33BA/image_name:${DOCKER_TAG}'
                sh 'docker logout'
            }
        }
        
        stage('Deploy') {
            steps {
                sshagent(['Vagrant_ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no vm2@192.168.1.98 << EOF
                            docker pull saif33BA/image_name:${DOCKER_TAG}
                            docker stop app_container || true
                            docker rm app_container || true
                            docker run -d --name app_container saif33BA/image_name:${DOCKER_TAG}
                        EOF
                    """
                }
            }
        }
    }
}
