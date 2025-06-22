library common
library functions
library admin

node {
    timestamps()
    try {
        stage('Build') {
            echo 'Building...'
            sh 'mkdir -p build && echo "Hello World" > build/output.txt'
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
        } else {
            echo "✅ Pipeline succeeded."
        }
    }
}
