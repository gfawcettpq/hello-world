defaultECSDeploymentPipeline([
    applicationBuildLabel: 'deploy-ec2',
    artifactDownloadName: 'helloworld.tar.gz',
    artifactDownloadPath: 'helloworld/tmp',
    artifactName: 'helloworld',
    buildScript: '''
cd ${APPLICATION_NAME}/src
tar czvf helloworld-${RELEASE}.tar.gz .
''',
    configPath: 'helloworld/jenkins/nightly1.yml',
    pipelineName: 'devops-helloworld-pipeline'
])
