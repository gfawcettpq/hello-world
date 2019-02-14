pipeline {
  agent none

  stages {
    stage('Build') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        echo 'Building...'
      }
    }
    stage('Test') {
      agent { 
        docker { image 'busybox' }
      }
      steps {
        echo 'Testing...'
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
  }
}
