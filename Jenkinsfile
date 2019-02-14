pipeline {
  agent none

  stages {
    stage('pre-build') {
      agent { 
        docker { image 'deployoryah' }
      }
      steps {
        echo 'jeeves inject devops-helloworld-pipeline'
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
    stage('Deploy') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        echo 'Deploying...'
      }
    }
    stage('Validate') {
      agent {
        docker { image 'busybox' }
      }
      steps {
        echo 'Validating...'
      }
    }
  }
}
