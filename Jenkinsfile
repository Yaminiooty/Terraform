pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    stages {
        
         stage('Access') {
            environment { 
                Secret_key = credentials('secret-text') 
            }
        }
        
        stage('terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform plan') {
            steps{
                sh 'terraform plan'
            }
        }
        stage('terraform apply') {
            steps{                  
                sh 'terraform apply --auto-approve'
            }
        }
    }

    
}
