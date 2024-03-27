pipeline {
    agent any
    environment {
        SONAR_SCANNER='/opt/sonar-scanner' // Corrected variable name
        DOCKER_CREDS = credentials('docker123')
        DOCKER_IMAGE = 'sivapujitha'
    }
    stages {        
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
                sh 'docker image build -t pyhon .'
            }
        }
        // push docker image to dockerhub
         stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker123', usernameVariable: 'DOCKER_CREDS_USR', passwordVariable: 'DOCKER_CREDS_PSW')]) {
                        sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW'
                    }
                    sh 'docker tag react $DOCKER_IMAGE/python:latest'
                    sh 'docker push $DOCKER_IMAGE/python:latest'
                }
            }
        }
        // run the container using docker image
        stage('Run') {
            steps {
                sh 'docker run -d -p 8000:8000 --name python python'
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
