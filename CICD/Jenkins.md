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
1. 
```
Q). How to backup Jenkins ?
```
Backing up Jenkins is a very easy process, there are multiple default and configured files and folders in Jenkins that you might want to backup. The backup can be taken and stored in another directory or that directory can be zipped and stored in s3. Below are the main things that I backup:
1. Configuration: The `~/.jenkins` folder. You can use a tool like rsync to backup the entire directory to another location.
2. Plugins: Backup the plugins installed in Jenkins by copying the plugins directory located in JENKINS_HOME/plugins to another location.
3. Jobs: Backup the Jenkins jobs by copying the jobs directory located in JENKINS_HOME/jobs to another location.
```
7. shared libraries in jenkins?
8. how do we define shared libraries?
9. how are shared libraries written?
10. how do you define a pipeline and call it?
11. what kind of app you deploy on the pipeline?
12. basic structure, folder structure of helm?
13. what command are you using deployment in helm
14. in the Jenkins pipeline, the pipeline is running successfully but the build is not happening, what are the issues?
15. typical deployment flow?
cicd workflow?
16. how do we do a full quality check?
17. jenkins file, different stages...
18. shared libraries in jenkins file?
19. typical structure of shared libraries...
20. are you aware of security scanning tools?
21. how do you pass the environment variables on docker build command.
22. any extension you are using for image scanning?
23. storing the secrets?
24. what is helm chart signing?
