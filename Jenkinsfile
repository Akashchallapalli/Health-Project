pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "JDK_11"
    }

    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "241227406647.dkr.ecr.us-east-1.amazonaws.com/e-telihealthimg"
        etelihealthRegistry = "https://241227406647.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/Akashchallapalli/Health-Project.git'
            }
        }

        stage('UNIT TEST') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh 'mvn sonar:sonar \
  -Dsonar.projectKey=ETeilhealth_dockerimg \
  -Dsonar.host.url=http://35.175.129.236 \
  -Dsonar.login=f456c8727162990fff4dd8c14837e43c839fdad8'
            }
        }

        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build("${appRegistry}:${BUILD_NUMBER}", "./")
                }
            }
        }

        stage('Upload App Image') {
            steps {
                script {
                    docker.withRegistry("${etelihealthRegistry}", registryCredential) {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
