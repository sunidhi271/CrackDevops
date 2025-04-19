# 📖 Gitlab Commands

Q: What are some ways to discard changes in your working directory and revert to the last committed state using Git commands?
Ans:
1. Discard untracked (new file that git doesnt know about yet) files: ``` git clean -f ```
2. Discard changes in tracked files (unstaged changes):
```
git checkout -- <file>
git checkout -- .
```
3. Discard all Unstaged (git add not done) and untracked (new folder that git doesnt know about yet) directories:
```
- git reset --hard
- git clean -fd
```
4. Discard staged changes (but keep the changes in working directory)
```
git reset <file>
for all files: git reset
```
5. Discard everything and revert to the last commit (including staged + unstaged + untracked):
```
git reset --hard HEAD
git clean -fd
```

Q: What is the difference between - git merge and git rebase command ?
```
git rebase: rewrites the commit history
git merge: eliminates the comit history of feature branch and keeps only that of master branch, after merging.
```
Q: If you commited your changes, but now you want to add a new line to commit message, then what is the git command to fix the message in the commit ?
```
git commit --amend
```

Q: How can you see the difference between two branch in git without merging them ? 
```
- git checkout <branch1>
- git diff <branch2>
```

Q: What is the git command to check the list of all the files changed in a commit ?
```
git diff-tree -r <current branch> --no-comment
```

Q: What is the use of git stash command ?
```
To save a copy of uncommitted changes.
```



# 📖 Gitlab CI 

Q:  In GitLab CI, how would you ensure that a job runs only on a specific branch?
```
test_job:
	stage: printBranch
	script: 
	  - echo $CI_COMMIT_BRANCH
	  - echo "Hello Worlds" > print.txt
	artifacts:
	  paths:
	    - print.txt
	  expire_in: 1h
	rules:
      - if: $CI_COMMIT_BRANCH == "main" && $CI_COMMIT_BRANCH != "otherBranch"
	when: manual    # by default auto
```

Q: How would you configure a GitLab CI job to execute only if a merge request is labeled with a specific tag, such as - release?
```
test_job:
  stage: build
	script:
      - echo "Running because MR is labels as $CI_MERGE_REQUEST_LABEL"
    rules:
      - if: '$CI_MERGE_REQUEST_LABEL =~ /hotfix|release/'
```

Q: Write a GitLab CI pipeline that triggers a pipeline in another project and passes environment variables securely to it ?
Parent Pipeline: .gitlab-ci.yml
```
stages:
- projectB
- child

trigger_inter_project:
	stage: projectB
	trigger:
	  project: projectB
	  branch: main
	  strategy: depend
	variables:
	- SECRET_TOKEN: $AZURE_SECRET
	  
trigger_child:
  stage: child
  trigger:
    include:
	  - local: child-pipeline.yml
```
Child Pipeline: .child-pipeline.yml
```
stages:
- test

test_python:
  script:
    - python --version
	- python install dependenies.txt
	- pytest test/
  parallel:
    matrix: 
	- PYTHON_VERSION: ["3.7", "3.8", "3.9"]
```


Q: Write a GitLab CI pipeline where the main pipeline triggers a child pipeline from another .gitlab-ci.yml file located in the same repository.
Ans: Parent Pipeline: .gitlab-ci.yml
```
stages:
  - trigger

trigger_child:
  stage: trigger
  trigger:
    include:
      - local: .gitlab/child-pipeline.yml
    strategy: depend

```
