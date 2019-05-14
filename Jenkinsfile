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
rm -rf helloworld/dist
mkdir -p helloworld/dist
tar czvf helloworld/dist/helloworld-${RELEASE}.tar.gz helloworld/src
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
