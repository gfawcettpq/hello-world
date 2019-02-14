pipeline {
  agent none

  stages {
    stage('pre-build') {
      agent { 
        docker { image 'deployoryah' }
      }
      steps {
        sh 'jeeves inject devops-helloworld-pipeline'
      }
    }
    stage('build-image') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        echo 'Building Image'
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
