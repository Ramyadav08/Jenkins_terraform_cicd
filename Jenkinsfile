pipeline {
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }

    stages {
        stage('CW') {
            steps {
                cleanWs()
            }
        }
        
        stage('Git code') {
            steps {
                git branch: 'main', url: 'https://github.com/Ramyadav08/Jenkins_terraform_cicd.git'
            }
        }
        
         stage('Sonar-analysis') {
            steps {
                script{
                    withSonarQubeEnv('sonar-server') {
                       sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Amazon \
                    -Dsonar.projectKey=Amazon '''
    
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        
         stage('NPM') {
            steps {
                sh 'npm install'
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t amazon ."
                       sh "docker tag amazon ramrekha08/amazon:latest "
                       sh "docker push ramrekha08/amazon:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image ramrekha08/amazon:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name amazon -p 3000:3000 ramrekha08/amazon:latest'
            }
        }

    }
}
