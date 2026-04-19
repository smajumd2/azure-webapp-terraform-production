pipeline {
    agent any 

    tools {
        terraform 'terraform'
    }

    stages {
        stage('Terraform Deployment') {
            steps {
                // All Terraform commands wrapped in one block for stability
                withCredentials([azureServicePrincipal('jenkins-cicd-sp')]) {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            // Standard cleanup
            deleteDir()
        }
    }
}
