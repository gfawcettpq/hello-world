defaultECSDeploymentPipeline([
    configPath: 'helloworld/jenkins/nightly1.yml',
    pipelineName: 'devops-helloworld-pipeline',
    artifactName: 'helloworld',
    artifactDownloadPath: 'helloworld/tmp',
    artifactDownloadName: 'helloworld.tar.gz'
    buildScript: '''
cd ${APPLICATION_NAME}/src
tar czvf helloworld-${RELEASE}.tar.gz .
'''
])
