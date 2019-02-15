pipeline {
  agent none

  parameters {
    string(name: 'RELEASE', description: 'artifact version', defaultValue: '1.0.0')
    string(name: 'APPLICATION_REVISION', description: 'application git commit', defaultValue: 'fakebro')
    string(name: 'APPLICATION_BRANCH', description: 'application git branch', defaultValue: 'master')
  }

  stages {
    stage('pre-build') {
      agent { 
        docker { image 'deployoryah' }
      }
      steps {
        sh 'jeeves load project devops-helloworld-pipeline helloworld/jenkins/nightly1.yml'
        sh 'jeeves inject devops-helloworld-pipeline'
        sh 'jeeves inject devops-helloworld-pipeline --to_file env.vars'
        load 'env.vars'
      }
    }
    stage('build-image') {
      agent {
        docker {
          image 'deployoryah'
          args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
      }
      when {
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      steps {
        sh 'stat -c "%g" /var/run/docker.sock'
        sh '$(aws ecr get-login --no-include-email --region us-east-1)'
        sh 'cd docker/hello_world && docker build --pull -t ${IMAGE_TAG}'
      }
    }
    stage('deploy') {
      agent { 
        docker { image 'busybox' }
      }
      when {
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      steps {
        echo 'Deploying...'
      }
    }
    stage('validate') {
      agent {
        docker { image 'busybox' }
      }
      when {
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      steps {
        echo 'Validating...'
      }
    }
    stage('publish') {
      agent {
        docker { image 'busybox' }
      }
      steps {
        echo 'Publishing...'
      }
    }
  }
}
