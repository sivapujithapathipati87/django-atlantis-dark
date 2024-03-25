pipeline {
    agent any
    environment {
        SONAR_SCANNER='/opt/sonar-scanner' // Corrected variable name
    }
    stages {
        // clone the source code from git
        stage('checkout') {
            steps {
                git 'https://github.com/sivapujithapathipati87/django-atlantis-dark.git'
            }
        }
        // sonar code quality check
        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonarqube') {
                    sh """
                    \${SONAR_SCANNER}/bin/sonar-scanner \
                    -Dsonar.projectKey=python \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://localhost:9000 \
                    -Dsonar.login=sqp_5ecda522e2bfd890796bbe764381d30dae231b99
                    """
                }
            }
        }
        // docker image build using dockerfile 
        stage('Docker Build') {
            steps {
                sh 'docker image build -t python .'
            }
        }
        // push docker image to dockerhub
         stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker123', usernameVariable: 'sivapujitha', passwordVariable: 'Rakhi#123$')]) {
                        sh 'docker login -u sivapujitha -p Rakhi#123$'
                    }
                    sh 'docker tag python sivapujitha/python:latest'
                    sh 'docker push sivapujitha/python:latest'
                }
            }
        }
        // run the container using docker image
        stage('Run') {
            steps {
                sh 'docker run -d -p 3000:3000 --name python python'
            }
        }
        //trivy image scanner
        stage('Trivy image scan') {
            steps {
                sh 'trivy image python'
            }
        }
    }
    // email notification
         post {
           success {
                    mail subject: 'build stage succeded',
                          to: 'pujisiri2008@gmail.com',
                          body: "Refer to $BUILD_URL for more details"
            }
           failure {
                    mail subject: 'build stage failed',
                         to: 'pujisiri2008@gmail.com',
                         body: "Refer to $BUILD_URL for more details"
                }
        }
}
