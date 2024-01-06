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
                         -Dsonar.host.url=http://100.25.200.100 \
                         -Dsonar.login=7852a247c95d20cbd61dcd3edf682e9d5767cb18'
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
