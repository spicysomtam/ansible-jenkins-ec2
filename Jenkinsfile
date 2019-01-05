pipeline {
  agent { label 'master' }

  parameters {
    string(name: 'aws_cred', defaultValue: 'jenkins', description: 'Aws credential')
    string(name: 'region', defaultValue: 'eu-west-1', description: 'aws region')
    choice(name: 'action', choices: ['deploy', 'destroy'], description: 'Deploy or destroy the stack.')
  }

  options {
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
    withAWS(region: params.region, credentials: params.aws_cred)
    buildDiscarder(logRotator(numToKeepStr: '5'))
    ansiColor('xterm')
  }
  
  stages {

    stage('Action') {
      steps {
        script {
          ansiblePlaybook(
            playbook: "${params.action}.yaml",
            inventory: 'localhost,',
            extraVars: '-c local',
            colorized: true)
        }
      }
    }
  }

  post {
    always {
      script {
        deleteDir()
      }
    }
  }
}
