pipeline {
   agent {label "slave"}
	
	environment {
		ACTION = "${params.Deployment}"
  }
	options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
  }
	
   parameters {
        choice(name: 'Environment', choices: ['Dev', 'QAS', 'Prod'], description: 'Select the environment')
        choice(name: 'Deployment', choices: ['plan', 'apply', 'destroy'], description: 'Select the type of deployment')
        choice(name: 'Region', choices: ['us-east-1', 'us-east-2'], description: 'Select the region')
        choice(name: 'Colour', choices: ['Blue', 'Green'], description: 'Select the colour')
        
    }
   stages {
        stage('SCM') {
            steps {
		cleanWs()    
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-jenkins', url: 'https://github.com/sathiya1987/aws-eks.git']]])
                sh "ls -lart ./*"
            }
        } 
        stage('validate'){
            steps{
 
		dir('eks') {
                sh "pwd"
	        sh 'terraform init'
                sh 'terraform validate'		
    }    
                
            }
        }
        stage('Build'){
            when { anyOf{
                                                environment name: 'ACTION', value: 'plan';
						environment name: 'ACTION', value: 'apply'
            }
            } 
            steps{  
                script {
				withCredentials([
								[ $class: 'AmazonWebServicesCredentialsBinding',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
									credentialsId: 'e82ebe19-e54f-43dd-8af6-ce4d8199eaa1',
								]]){
				
				dir('eks') {
                sh "pwd"
	       sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
    }  
			
				}	
            }
        }
        }
        stage('Deploy'){
            when { anyOf{
              environment name: 'ACTION', value: 'apply'
            }
               
            }
            steps{
		    
		 script {
				withCredentials([
								[ $class: 'AmazonWebServicesCredentialsBinding',
									accessKeyVariable: 'AWS_ACCESS_KEY_ID',
									secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
									credentialsId: 'e82ebe19-e54f-43dd-8af6-ce4d8199eaa1',
								]]){
				
		dir('eks') {
                sh "pwd"
	       sh 'terraform apply  -var-file=terraform.tfvars '
    }  
			
				}	
            }   
		    
                
            }
        }
    }
}

