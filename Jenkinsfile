pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "JDK_11"
    }

    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/Akashchallapalli/Health-Project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }

            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.jar'
                }
            }
        }

        stage('UNIT TEST') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }
         tage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }
            steps {
               withSonarQubeEnv('sonar') {
                   sh '''${scannerHome}/bin/sonar-scanner 
                mvn sonar:sonar \
                    -Dsonar.projectKey=E-Telihealth \
                    -Dsonar.host.url=http://18.207.3.70 \
                    -Dsonar.login=b2ee88c3d76f5279667c7eb0f51b40ce8fb1a6f9

              }
            }
        }
         stage('UploadArtifact') {
             steps {
                script {
                nexusArtifactUploader(
                nexusVersion: 'nexus3',
                protocol: 'http',
                nexusUrl: '44.201.152.111:8081',  // Remove extra 'http://'
                groupId: 'com.ns.healthproject',
                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                repository: 'E-Telihealth',
                credentialsId: 'nexuslogin',
                artifacts: [
                    [artifactId: 'E-Telihealth',
                     classifier: '',
                     file: 'target/E-Telihealth-0.0.1-SNAPSHOT.jar',
                     type: 'jar']
                ]
            )
        }
    }
}


    }
}
