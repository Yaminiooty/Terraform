pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    environment { 
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        
         
         stage('terraform format check') {
            steps{
                sh 'terraform fmt'
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
