pipeline {
    // 1. Where to run: 'any' means any available Jenkins runner/agent
    agent any

    // 2. Load the Terraform tool you configured in 'Global Tool Configuration'
    tools {
        terraform 'terraform' 
    }

    // 3. Securely pull your Azure secrets into environment variables
    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        // 4. Download Terraform providers and initialize the remote backend
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        // 5. Preview what changes will be made (Safety Check)
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        // 6. Execute the plan and build the Azure Infrastructure
        stage('Terraform Apply') {
            steps {
                // We use -auto-approve because the pipeline is automated
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
    
    // 7. Clean up workspace after build
    post {
        always {
            // This ensures we only try to delete the directory if an agent was actually used
            node('any') {
                deleteDir()
            }
        }
    }
