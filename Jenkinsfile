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
                sh '''
SERVICE_URL=$(jeeves read parameter RESOURCES.BaseURL ${PIPELINE})
TARGET_GROUP_ARN=$(jeeves read parameter RESOURCES.DefaultTargetGroupARN ${PIPELINE})

firkin wait for stability ${APPLICATION_NAME}/jenkins/${ENVIRONMENT}.yml

firkin wait for target health --target_group_arn ${TARGET_GROUP_ARN}

kixx validate ${SERVICE_URL}

firkin test service ${SERVICE_URL} --test_path cucumber --tags @${APPLICATION_NAME}
'''
            }
        }
        stage('publish') {
            agent { 
                label 'deploy-ec2'
            }
            steps {
                sh '''
SERVICE_URL=$(jeeves read parameter RESOURCES.BaseURL ${PIPELINE})
STACK_NAME=$(jeeves read parameter STACK_NAME ${PIPELINE})

firkin publish ${IMAGE_TAG} --system ${SYSTEM} --group ${GROUP} --release ${RELEASE} --application_revision ${GIT_COMMIT} --infrastructure_revision ${GIT_COMMIT}
firkin activate ${IMAGE_TAG} ${ENVIRONMENT}

nimbus publish --stack_name ${STACK_NAME} --system ${SYSTEM} --environment ${ENVIRONMENT} --sub_environment ${SUB_ENVIRONMENT} --launch_ami_id ${IMAGE_TAG} --release ${RELEASE} --stack_url ${SERVICE_URL}
nimbus activate --stack_name ${STACK_NAME}
nimbus cleanup --stack_name ${STACK_NAME}
nimbus complete deployment --stack_name ${STACK_NAME}

'''
            }
        }
    }
}
