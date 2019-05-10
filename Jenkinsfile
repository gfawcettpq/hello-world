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
                label 'deploy-ec2'
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
                label 'docker-ec2'
            }
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                sh 'env'
                sh 'cd ${SERVICE_NAME} && mkdir -p tmp && rm -f tmp/*.jar && aws s3 cp s3://${S3_BUCKET}/${SERVICE_NAME}/artifacts/pqservices-${SERVICE_NAME}-${IVY_BUILD_NUMBER}.jar tmp/pqservices-${SERVICE_NAME}.jar'
            }
        }
        stage('deploy') {
            agent { 
                label 'deploy-ec2'
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
                label 'deploy-ec2'
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
                label 'deploy-ec2'
            }
            steps {
                echo 'Publishing...'
            }
        }
    }
}
