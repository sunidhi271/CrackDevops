library common
library functions
library admin

node('TestApp') {
    timestamps()
    try {
        stage('Build') {
            echo 'Building...'
            sh 'mkdir -p build && cd build && echo "starting build.." > build/output.txt'
            withCredentials([credentialId: 'registryCreds', username: 'USER', password: 'TOKEN']){
                sh 'docker login https://registry.test.abc.com -u ${USER} -p ${TOKEN}'
            }
            sh 'docker build . -t testApp:{env.BUILD_NAME} > build/build-op.txt'
        }
        
        stage('Archive Artifact') {
            archiveArtifacts artifacts: 'build/*.txt', allowEmptyArchive: true
        }

        stage('Trigger the other job') {
            build job: 'release_pipeline', parameters: [string(name: 'currentbranch' , value: 'env.gitlabTargetBranch')], propagate: false, wait: true
        }

    } catch (err) {
        echo "Error occurred: ${err}"
        currentBuild.result = 'FAILURE'
        throw err
    } finally {
        if (currentBuild.result == 'FAILURE') {
            echo "Pipeline failed. Please investigate."
            cleanWs()
        } else {
            echo "✅ Pipeline succeeded."
            cleanWs()
        }
    }
}
