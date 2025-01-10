pipeline {
    agent any
     tools { 
        jdk 'JDK17'
    }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        DOCKER_TAG = getVersion()
        DOCKER_CREDENTIALS = credentials('docker-credentials')
    }
    
    stages {
        stage('Clone Stage') {
            steps {
                git 'https://github.com/saif33BA/datacamp.git'
            }
        }
        
        stage('Docker Build') {
            steps {
                sh 'docker build -t saif33BA/image_name:${DOCKER_TAG} .'
            }
        }
        
    }
}

def getVersion() {
    def version = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    return version
}
