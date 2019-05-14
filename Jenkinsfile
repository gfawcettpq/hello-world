defaultECSDeploymentPipeline([
    pipeline: [
        configPath: 'helloworld/jenkins/nightly1.yml',
        name: 'devops-helloworld-pipeline'
    ],
    build: [
        label: 'deploy-ec2',
        targetPath: 'helloworld/dist',
        targetName: 'helloworld-${RELEASE}.tar.gz',
        script: '''
cd ${APPLICATION_NAME}
tar czvf helloworld-${RELEASE}.tar.gz src
''',
    ],
    artifact: [
        uploadBucket: 'pq-devops',
        uploadPath: 'helloworld/artifacts'
    ],
    image: [
        artifactDownloadName: 'helloworld.tar.gz',
        artifactDownloadPath: 'helloworld/tmp',
    ],
])
