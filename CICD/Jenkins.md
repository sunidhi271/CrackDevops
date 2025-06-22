Q). What is latest version of jenkins ?
```
The latest version available in 2.515, but the last time our team upgraded jenkins, it was 2.504.x 
```
Q). What are different ways to trigger a Jenkins Pipeline ?
```
1. Poll SCM: periodically checks a source code repository for changes (we specify a cronjob schedule for it ) and triggers a build when a change is detected. So, if Jenkins finds a change during polling, it triggers a build.
2. Gitlab Webhooks: While creating jenkins pipeline on enabling the trigger option to build when a change is pushed to Gitlab, it gives a URL. That URL we have to configure in gitlab webhooks settings and enable the respective actions which would trigger the pipelie (in my case, I use only Merge Request Events). Whenever the event occurs Jenkins sends a payload (json with all details) to the Jenkins pipeline and starts the pipeline.
3. Manual Trigger: By clicking the build now button.
4. Trigger from Another Job: You can configure Job A to trigger Job B once it finishes.
5. Trigger via API: Jenkins exposes REST API to trigger builds (curl -X POST http://<jenkins_url>/job/<job_name>/build?token=YOUR_TOKEN), So, it can be triggered using scripts or jobs etc.
```
Q). cicd workflow, what kind of pipeline ?
```
1. Code Commit: Developers commit code changes to a Git repository (microservice) hosted on Gitlab.
2. Jenkins Build: Jenkins is triggered to build the code using gitlab webhook. In the build pipeline, the code is built, scaned using sonarqube, tested, then build image is scanned, and pushed to repository. Mostly these pipelines are created and maintained by Development teams.
3. Code Analysis: Sonar is used to perform static code analysis to identify any code quality issues, security vulnerabilities, and bugs.
4. Security Scan: AppScan is used to perform a security scan on the application to identify any security vulnerabilities.
5. Deploy to Dev Environment: If the build and scans pass, Jenkins deploys the code to a development environment managed by Kubernetes.
6. Continuous Deployment: ArgoCD is used to manage continuous deployment. ArgoCD watches the Git repository and automatically deploys new changes to the development environment as soon as they are committed.
7. Promote to Production: When the code is ready for production, it is manually promoted using ArgoCD to the production environment.
8. Monitoring: The application is monitored for performance and availability using Kubernetes tools and other monitoring tools.
```
Q). How to use sonarqube for code analysis ?
```
- Install Sonarqube: We install sonarqube on the same instance where Jenkins is installed, as a service, not as a container. Create Authentication token in SonarQube UI.
- Install Plugin in Jenkins: Install sonarqube plugin in Manage Jenkins --> Plugin section.
- Configure SQ Plugin: SonarQube server configured under Manage Jenkins → Configure System. Give a name, sq server url and authentication token (type: Secret Text).
```
Q). Use of webhook and purpose of webhook ?
```
The primary purpose of a webhook in Jenkins is to automatically trigger a job or pipeline when there's a change in the source code repository — without polling. Jenkins exposes an HTTP endpoint, e.g., http://jenkins.example.com/github-webhook/
You configure this URL as a webhook in your Git provider (GitHub, GitLab, etc.)
When a code event happens (e.g. push), the Git provider sends an HTTP POST to that URL
Jenkins receives the payload, matches it to the corresponding job, and triggers the build
```
Q). Stages of pipeline ?
```
NOD Pipeline:
- Trigger pipeline: checks whether its a MR or direct commit to master(by checking MR id env variable), the state of MR (env.gitlabMergeRequestState). Then once merged or commited, it makes a list of changes files and extracts the top level folder names. Then it matches the folder names with the list of folder names given and triggers jenkins job for the matched folder sequentially (wait: true), by passing branch name as parameter. It succeeds if child jobs were triggered and fails if no folder changes.
- Build Pipeline: Clone stage - clones the repository and cd to topFolder or microservice folder, then runs dockerfile linter. Build stage - builds the app by making the build number as the tag number, then pushes the image to registry and runs a Anch0re scan on the pushed image. Last stage -  is SQ scan which checks sonar settings and then runs scan and waits for quality gate. At the end cleans up the workspace.
- Release pipeline: another trigger pipeline checks MRs state and triggers the release pipeline once MR is merged. First is ImageCheck stage in which gitlab repo is cloned and its value file is read and the image versions of each image is extracted and a final file is prepared which has registry prefixed with image:tag, and then it logins to registry and checks the availablility of each image in the registry. Second stage is git repo tagging, in which it calls a function which returns a tag name and another function which creates the tag and pushes it in the remote repo through gitlab api. 
```
Q). How to backup Jenkins ?
```
Backing up Jenkins is a very easy process, there are multiple default and configured files and folders in Jenkins that you might want to backup. The backup can be taken and stored in another directory or that directory can be zipped and stored in s3. Below are the main things that I backup:
1. Configuration: 
- The `~/.jenkins` folder. You can use a tool like rsync to backup the entire directory to another location.
- /var/lib/jenkins/nodes folder for the Jenkins node configurations
- /var/lib/jenkins/*.ssh files
- /var/lib/jenkins/*.kube files
2. Plugins: Backup the plugins installed in Jenkins by copying the plugins directory located in JENKINS_HOME/plugins to another location.
3. Jobs: Backup the Jenkins jobs by copying the jobs directory located in JENKINS_HOME/jobs to another location.
4. Secrets: Backup all the secrets stored to your folder (/var/lib/jenkins/secret* files)
5. Copy all the xmls: /var/lib/jenkins/*.xml files

rsync command:
1. rsync -a -r -p -A -X -o -g -t -a -v -h -z --progress --delete --exclude=logs --exclude=workspace --exclude=microservice --exclude=scm-sync-configuration -e ssh /var/lib/jenkins/. root@$HOST:/var/lib/jenkins ) >> /tmp/RSYNCLog-$time.log 2>&1
2. rsync -a -r -p -A -X -o -g -t -a -v -h -z --progress -e ssh /etc/sysconfig/jenkins root@$HOST:/etc/sysconfig/jenkins

```
Q). What is the deployment and cicd flow in your current company ?
```
- Trigger build: There is a repo where the code of more than 30 microservices are maintained, each ms separated by folder name inside the repo. Whenever there is a MR Raised, a build trigger pipeline gets triggered which observes the state of the MR and when its merged, it observes or lists the changed files. From the changed files it scrape the unique list of top folders, and then matches the topFolder names with a list of allowed microservices. For matched folder name it triggers the pipeline of the respective microservice.
- Build pipeline: First stage - Clones the branch of that repo and then runs dockerfile linter. Second stage - builds the app by making the build number as the tag number, then pushes the image to registry and runs a Anchore scan on the pushed image. Third stage - SQ scan which checks sonar settings and then runs scan and waits for quality gate. Fourth stage - updates the dev value file in another repo where helm templates of the ms are maintained. 
- Argocd - Observes the changes, and applies the changes directly in cluster.
- Weekly release - each commit or MR to the green branch of template repo or value file repo, creates a tag. A final tag is picked manually and applied to preproduction value file. This tag application then triggers a gitlab-ci pipeline which creates a list of images that are going as part of the release in - stage 1. In stage 2 - It extracts only unique list of images that are coming from our private registry and is validating their existance in our repistry. Release fails when tags are not present in registry. Stage -3: The unique list is pushed to another gitlab repo for Operations team reference. Stage-4: The gitlab code of microservice template repo, value file repo, and infra repo is synced to Customer gitlab.
Release tag is first applied to small DCs, and the next day it is applied to big DCs.
```
Q). What is shared libraries in jenkins? and How are shared libraries written?
```
Shared Libraries in Jenkins are a way to centralize and reuse common pipeline code across multiple Jenkinsfiles or jobs. Instead of duplicating functions or pipeline logic in each job, you can write that logic once in a shared library and call it from any pipeline. The functions to be used in share library are defined first in vars folder in repo. Then in jenkins  Global Shared Library (for all pipelines):
- Go to Manage Jenkins → Configure System
- Scroll to Global Pipeline Libraries
- Add the library details (branch, repo url, retrival method scm)
OR, folder level libraries can also be created, i.e, pipelines under the same folders can use it.

Click Add
```
```
(root of Git repo)
├── vars/
│   └── myPipeline.groovy       ← Scripted steps callable in Jenkinsfile
├── src/
│   └── org/
│       └── myorg/
│           └── utils.groovy    ← Groovy classes & helper functions
├── resources/
│   └── someTemplate.txt        ← Templates or configs
└── README.md
```

Q). What is typical structure of shared libraries ?

Q). in the Jenkins pipeline, the pipeline is running successfully but the build is not happening, what are the issues?
 
Q). how do we do a full quality check?

Q). Are you aware of security scanning tools?
- SonarQube:
- Trivy:
- Anchore:
- Clair:
- Blackduck:
- Talko:

Q) How sonarqube works ?

Q) How to store secrets in jenkins ?

Q) How to debug a slow pipeline ?

Q) Explain challenging CICD issues you fixed ?

Q) How to implement monitoring and alerting post deployment ?

Q). storing the secrets?

