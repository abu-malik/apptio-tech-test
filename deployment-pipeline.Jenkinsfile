def triggeredBy = currentBuild.getRawBuild().getCauses()[0].getUserId()
pipeline {
  agent any
  options {
    ansiColor colorMapName: 'XTerm'
    timestamps()
  }
  parameters {
    string(name: 'artifact', defaultValue: 'webapp.tar.gz', description: 'specify name of .gz artifact file')
  }
  
  environment {
    AWS_ACCESS_KEY_ID               = credentials("aws_access_key_PROD")
    AWS_SECRET_ACCESS_KEY           = credentials("aws_secret_key_PROD")
  }
  stages {
    stage("Preflight") {
      steps {
        echo "Preflight..."
        sh "chmod 755 deploy_application.sh"
      }
    }
    stage("App deploy") {
      steps {
        echo "Deploying..."
        sh "deploy_application.sh ${artifact}"
      }
    }
    stage("Clean workspace") {
      steps {
      deleteDir()
      }
    }
  }
}
