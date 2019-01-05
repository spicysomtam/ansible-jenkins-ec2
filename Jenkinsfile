pipeline {
  agent { label 'master' }

  parameters {
    string(name: 'aws_cred', defaultValue: 'jenkins', description: 'Aws credential')
    string(name: 'region', defaultValue: 'eu-west-1', description: 'aws region')
    string(name: 'key_name', defaultValue: 'my-key', description: 'ec2 key pair')
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
          currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action
          ansiblePlaybook(
            playbook: "${params.action}.yaml",
            inventory: 'localhost,',
            colorized: true,
            extras: '-c local',
            extraVars: [
              key_name: params.key_name
            ])
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
