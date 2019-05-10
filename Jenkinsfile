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
                sh '''
jeeves load project devops-helloworld-pipeline helloworld/jenkins/nightly1.yml
jeeves inject devops-helloworld-pipeline
jeeves inject devops-helloworld-pipeline --to_file env.vars
'''
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
                sh '''
firkin docker login --account pqis

cd ${APPLICATION_NAME}
docker build -t ${IMAGE_TAG} .

firkin create image repository ${IMAGE_TAG} --idempotent

docker push ${IMAGE_TAG}
'''
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
                sh '''
nimbus create stack ${STACK_TEMPLATE} ${APPLICATION_NAME}/jenkins/${ENVIRONMENT}.yml --idempotent --output ${PIPELINE} --apply_tags

jeeves rename parameter RESOURCES.BaseURL SERVICE_URL ${PIPELINE}

firkin register task ${APPLICATION_NAME}/jenkins/${ENVIRONMENT}.yml

TARGET_GROUP_ARN=$(jeeves read parameter RESOURCES.DefaultTargetGroupARN ${PIPELINE})
firkin poke service ${APPLICATION_NAME}/jenkins/${ENVIRONMENT}.yml --additional_parameters load_balancers.target_group_arn=${TARGET_GROUP_ARN} --idempotent --link_from ${PIPELINE}
'''
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
