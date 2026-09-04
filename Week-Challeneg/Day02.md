# 🔥 Day 2 Question Set

## Git — 5

### What is the difference between git merge and git rebase?

Merge gives a non-linear history, while rebase gives a linear history. In merge, branch history is maintained, while in rebase, feature changes are placed on top of the latest main.

### What is a pull request, and why is it used?
“A pull request is a request to merge our changes from one branch into another branch. It is used to review the code, get approval, and then merge the changes.”

### How do you resolve a Git merge conflict?

“First, I will identify the files having conflicts using git status. Then I will open those files and manually resolve the conflict by keeping the correct changes. After that, I will use git add and commit the changes. Finally, I will push the changes to the remote repository.”


### *What is a Git branch, and why do we use branches?
A branch is a separate copy of the code where we can develop and test new changes without affecting the main branch.

### What is .gitignore and why is it used?

“.gitignore is a file where we define files and folders that we don't want Git to track or commit. For example, log files, temporary files, and sensitive files like .env.”

## AWS + Linux — 5

### An EC2 instance is running but the application is down. How will you troubleshoot it?
### What is the difference between Security Group and NACL?
### *An EC2 server has 90% disk utilization. What steps will you take?
### How will you check which process is consuming high CPU on Linux?
### How will you troubleshoot a Linux server where a service is not running?

## Docker — 5

### What is the difference between CMD and ENTRYPOINT?

### What is a Docker volume and why do we use it?

### *A Docker container starts and immediately exits. How will you troubleshoot it?

### What is the difference between EXPOSE and publishing a port with -p?

“EXPOSE only defines the port in the Dockerfile for Documentation; it does not actually publish the port. -p publishes the container port to the host so we can access the application from outside the container.”

### How do you pass environment variables to a Docker container?

We can define environment variables in the Dockerfile using ENV. We can also pass them at runtime using docker run -e

## Terraform — 5

### What is a Terraform backend?

“A Terraform backend defines where Terraform stores the state file. It can be local or remote, for example, S3.”

### What is remote state and why do we use it?

“Remote state means storing the Terraform state file in a remote location like S3 instead of the local machine. We use it so multiple team members can work with the same state, and we can use state locking to avoid conflicts when multiple users run Terraform at the same time.”

### *What is Terraform state and why is it important?

“Terraform state is the information about the resources created or managed by Terraform. It is stored in the terraform.tfstate file and helps Terraform track those resources and identify what changes are required.”

### What is the difference between count and for_each?

“Both are used to create multiple resources. With count, resources are created using an index, while with for_each, resources are created using map or set values.”

```
count → resource[0], resource[1], resource[2]

for_each → resource["dev"], resource["prod"]

```

### What happens when you run terraform apply?

“When we run terraform apply, Terraform first checks the current state and creates an execution plan. After approval, it applies the required changes to the infrastructure and updates the Terraform state file.”

## Jenkins — 5

### What is a Jenkins Agent/Node?

“A Jenkins Agent is a machine where Jenkins runs the actual build and deployment tasks. The Jenkins controller manages the jobs and assigns them to agents. Agents can be used to run builds on different environments.”

### What is a Jenkinsfile?
“A Jenkinsfile is a file where we define the Jenkins pipeline as code. It contains different stages such as checkout, build, test, Docker build, and deployment. Usually, we keep the Jenkinsfile in the Git repository along with the application code.”

### *How will you troubleshoot a Jenkins pipeline that suddenly starts failing?

“First, I will check the Jenkins console output and identify which stage has failed. Then I will check the exact error and troubleshoot based on the error. It may be related to the Git URL, credentials, code quality, filesystem, image vulnerability, Jenkins agent being offline, or resource issues. Once I find the root cause, I will resolve the issue and rerun the pipeline.”

### What is the difference between Declarative and Scripted Pipeline?

“Declarative Pipeline has a predefined and structured syntax, so it is easier to read and maintain. Scripted Pipeline is more flexible and uses Groovy scripting, so we can write more complex logic.”

### How do you securely store credentials in Jenkins?

“I will store credentials in Jenkins Credentials Manager instead of hardcoding them in the Jenkinsfile. Jenkins provides different credential types such as username and password, SSH keys, and secret text. Then I will use those credentials in the pipeline through Jenkins credential IDs.”

## Kubernetes — 5

### What is the difference between Deployment and StatefulSet?

“Deployment is mainly used for stateless applications. It manages ReplicaSets and provides features like application updates and rollback.”
“StatefulSet is used for stateful applications where Pods need stable names, stable network identity, and persistent storage.”

### What is a DaemonSet and where is it used?

“DaemonSet is run on worker nodes and it is basically used for monitoring and logging. It ensures one Pod runs on each worker node.

### *A Pod is in CrashLoopBackOff. How will you troubleshoot it?

“First, I will check which Pod is in CrashLoopBackOff using kubectl get pods. Then I will check the current and previous logs. After that, I will run kubectl describe pod and check the Events section to identify the exact reason. It may be related to application issues, configuration, resources, probes, or storage. Based on the error, I will resolve the issue.”

### What is HPA and how does it work?

“HPA stands for Horizontal Pod Autoscaler. It automatically increases or decreases the number of Pods based on resource utilization such as CPU or memory. For example, if CPU utilization increases, HPA can increase the number of Pods, and when the load decreases, it can reduce the number of Pods.”

### What is the difference between ConfigMap and Secret?

“ConfigMap is used to store non-sensitive configuration data, while Secret is used to store sensitive data such as passwords, tokens, and API keys. Secret data is stored in Base64 encoded format by default.”
