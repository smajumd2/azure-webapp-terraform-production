pipeline {
    agent {
        node {
            label '' // Leaves the label blank to find any available executor
        }
    }

    tools {
        // This must match the name you gave the tool in 'Manage Jenkins > Tools'
        terraform 'terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                // This pulls your main.tf, variables.tf, and backend.tf
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Using the Azure Service Principal ID you created in Jenkins
                withCredentials([azureServicePrincipal('azure-sp')]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([azureServicePrincipal('azure-sp')]) {
                    // Saves the plan to a file to ensure 'Apply' uses the exact same plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal('azure-sp')]) {
                    // Executes the deployment to Azure
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            // Clean up sensitive files and the plan from the Jenkins workspace
            node('any') {
                deleteDir()
            }
        }
    }
}
