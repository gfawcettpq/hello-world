defaultECSDeploymentPipeline([
    configPath: 'helloworld/jenkins/nightly1.yml',
    pipelineName: 'devops-helloworld-pipeline',
    artifactName: 'hellowork'
    buildScript: '''
cd ${APPLICATION_NAME}/src
tar czvf helloworld-${RELEASE}.tar.gz .
'''
])
