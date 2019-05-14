defaultECSDeploymentPipeline([
    applicationBuildLabel: 'deploy-ec2',
    artifactDownloadName: 'helloworld.tar.gz',
    artifactDownloadPath: 'helloworld/tmp',
    artifactName: 'helloworld',
    buildScript: '''
cd ${APPLICATION_NAME}
tar czvf helloworld-${RELEASE}.tar.gz src
''',
    configPath: 'helloworld/jenkins/nightly1.yml',
    pipelineName: 'devops-helloworld-pipeline'
])
