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
                sh 'mvn sonar:sonar -Dsonar.projectKey=E-Telihealth_docker 
                                    -Dsonar.host.url=http://52.87.235.3 
                                    -Dsonar.login=5820816f46eecebc55fd7bce035f7f44decd17ca'
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
