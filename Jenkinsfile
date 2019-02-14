pipeline {
  agent none

  parameters {
    string(name: 'RELEASE', description: 'artifact version')
    string(name: 'APPLICATION_REVISION', description: 'application git commit')
    string(name: 'APPLICATION_BRANCH', description: 'application git branch')
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
      agent any
      when {
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      steps {
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
