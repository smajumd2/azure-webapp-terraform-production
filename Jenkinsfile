pipeline {
    agent any
    tools { 
        terraform 'terraform' 
    }

    environment {
        // This pulls the "azure-sp" credential package from Jenkins
        AZURE_CREDS = credentials('azure-sp')
    }

    stages {
        stage('Terraform Execution') {
            environment {
                // Map the sub-values of the credential to ARM variables
                ARM_CLIENT_ID       = "${env.AZURE_CREDS_CLIENT_ID}"
                ARM_CLIENT_SECRET   = "${env.AZURE_CREDS_CLIENT_SECRET}"
                ARM_SUBSCRIPTION_ID = "${env.AZURE_CREDS_SUBSCRIPTION_ID}"
                ARM_TENANT_ID       = "${env.AZURE_CREDS_TENANT_ID}"
            }
            steps {
                // Now run all commands inside this stage
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            deleteDir()
        }
    }
}
