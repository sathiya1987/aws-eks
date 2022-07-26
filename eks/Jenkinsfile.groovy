pipeline {
   agent {label "slave"}
   parameters {
        choice(name: 'Environment', choices: ['Dev', 'QAS', 'Prod'], description: 'Select the environment')
        choice(name: 'Deployment', choices: ['plan', 'apply', 'destroy'], description: 'Select the type of deployment')
        choice(name: 'Region', choices: ['us-east-1', 'us-east-2'], description: 'Select the region')
        choice(name: 'Colour', choices: ['Blue', 'Green'], description: 'Select the colour')
        string(name: 'PARAMETERS_FILE_NAME', defaultValue: 'example-parameters.properties', description: 'Enter the Parameters File Name (Must contain file extension type *.properties)')
    }
   stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-jenkins', url: 'https://github.com/sathiya1987/aws-eks.git']]])
                sh "ls -lart ./*"
            }
        } 
        stage('validate'){
            steps{
                
                sh 'terraform init'
                sh 'terraform validate'
            }
        }
        stage('Build'){
            when { expression{
               params.Deployment == "plan"
               params.Deployment == "apply"
            }
            } 
            }
            steps{
                script {
						wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
							withCredentials([
								[ $class: 'AmazonWebServicesCredentialsBinding',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
									credentialsId: 'aws_credential',
									]])}
                sh 'terraform plan -var-file=terraform.tfvars'
            }
        }
        stage('Deploy'){
            when { anyOf{
               ${params.Deployment} == "apply"
            }
               
            }
            steps{
                sh 'terraform apply --auto-approve -var-file=terraform.tfvars '
            }
        }
    }
}

