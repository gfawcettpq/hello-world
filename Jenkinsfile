pipeline {
  agent none

  parameters {
    string(name: 'RELEASE')
    string(name: 'APPLICATION_REVISION')
    string(name: 'APPLICATION_BRANCH')
  }

  stages {
    stage('pre-build') {
      agent { 
        docker { image 'deployoryah' }
      }
      steps {
        sh 'jeeves load project devops-helloworld-pipeline helloworld/jenkins/nightly1.yml'
        sh 'jeeves inject devops-helloworld-pipeline --to_file env.vars'
        load 'env.vars'
      }
    }
    stage('build-image') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        sh 'firkin docker login --account pqis'
        sh 'cd docker/hello_world && docker build --pull -t '
      }
    }
    stage('deploy') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        echo 'Deploying...'
      }
    }
    stage('validate') {
      agent {
        docker { image 'busybox' }
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
