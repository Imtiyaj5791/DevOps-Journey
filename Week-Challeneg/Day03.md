# 🔥 Day 3 Question Set

# Git — 3

### What is a Git branching strategy, and which branching strategy have you used?

“We follow a Git branching strategy to avoid directly making changes to the main branch. In my organization, we have a development branch. When a new feature needs to be added, the development team creates a feature branch from the development branch. Once the code is pushed, it goes through testing. After successful testing, we create a Pull Request for approval. Once it is approved, we merge it into the main branch. We also have a hotfix branch for urgent production fixes.”

### What is the difference between git clone and git pull?

Git clone copies the remote repository to the local machine, while Git pull downloads the latest changes from the remote repository and merges them automatically.

### How do you undo the last Git commit?

To undo the last commit, I can use git revert or git reset --soft HEAD~1, depending on whether the commit is already pushed or still local.”

# AWS + Linux — 5

### What happens when you enter a URL in the browser and access an application running on AWS?

“When a user enters the URL, DNS resolves the domain to the Load Balancer. The Load Balancer forwards the request to a healthy target in the Target Group, where our application is running. The EC2 instances are managed by Auto Scaling Group.”

### What is an IAM Role, and why do we use it with EC2?

“An IAM Role provides temporary credentials to an AWS resource like EC2. We use IAM Roles instead of hardcoding access keys, which is more secure.”

### How will you troubleshoot if a Linux server is reachable but the application is not responding?
“First, I will check on the OS side. I will log in to the server and check whether the application is accessible locally using curl localhost. Then I will check whether the application port is listening using ss -tulnp and check the service status using systemctl status <service-name>. I will also check CPU, memory, and disk utilization.

After that, I will check the AWS side, including the Security Group and NACL, to verify whether the required port is allowed. If the application is behind a Load Balancer, I will check the Load Balancer and Target Group health. If everything looks fine, I will collect the application/service logs using journalctl and coordinate with the application team if required.”

### How do you troubleshoot high CPU utilization on a Linux server? *
I Know

### How do you troubleshoot high disk utilization on a Linux server? *

# Docker — 3
### What is a Dockerfile, and why do we use it?

“A Dockerfile is a file where we define the base image, copy the application code, install dependencies, expose the port, and define the CMD. We use the Dockerfile to build a Docker image, and then we use the image to create a container.”

### What is the difference between a Docker image and a Docker volume?

“A Docker image is a pre-built template used to create containers. It contains the application code, dependencies, and required libraries. A Docker volume is used to store persistent data.”

### How do you check CPU and memory usage of a Docker container?

“I will use docker stats to check CPU and memory utilization of the container. If required, I can also go inside the container using docker exec and check processes using top and memory using free -h.”

🔹 Terraform — 5
### What is a Terraform Dynamic Block, and why do we use it?

“A Dynamic Block in Terraform allows us to create nested blocks dynamically from a set of input values, instead of defining each block separately.”

For example, instead of manually writing multiple ingress blocks in a Security Group, we can use a Dynamic Block to generate them automatically.


### What is terraform init, and why is it required?

terraform init initializes the Terraform working directory. It downloads the required provider plugins to communicate with cloud providers, and it initializes the backend, such as local or S3, where the Terraform state is stored.

### What is a Terraform Module, and why do we use it?

A Terraform Module is a reusable collection of Terraform configuration files. We use modules to avoid writing the same infrastructure code again and again. We can create a module once and reuse it with different values. The root module is the caller, and the child module contains the actual reusable Terraform code.

### What is Terraform state, and why is it important? *

Terraform state contains information about the resources created or managed by Terraform. It is normally stored in a terraform.tfstate file. Terraform uses the state to track the current infrastructure and determine what changes are required during the next plan or apply.

### What is the difference between count and for_each? *

Both count and for_each are used to create multiple instances of a resource. With count, resources are created using numeric indexes, while with for_each, resources are created using keys from a map or set, such as app and db.

# Jenkins — 3

### Explain the CI/CD pipeline you have worked on or practiced in your project.

In my organization, we mainly use Jenkins for CI/CD pipelines. Our pipeline consists of multiple stages.

First, Jenkins checks out the source code from Git. Then we run unit tests to validate the code. After that, we build the application and generate the artifact.

Next, we perform code quality analysis using SonarQube and security scanning using Trivy. The generated artifact is stored in Nexus/AWS CodeArtifact Repository.

After that, we build the Docker image and perform a vulnerability scan on the Docker image using Trivy. Once the image passes the required checks, we push it to Amazon ECR.

Then we deploy the application to the target environment. Finally, we perform smoke testing to verify that the application is working correctly after deployment.

### What are Jenkins Pipeline stages, and why do we use them?

Done in previous

### How does Jenkins get the source code from Git?

Jenkins gets the source code from the Git repository using the Git plugin. We configure the Git repository and credentials in the Jenkins pipeline. A webhook can be configured so that whenever there is a code change, Git triggers Jenkins and the pipeline starts. Jenkins then checks out the latest code into the workspace.

# Kubernetes — 5

### What happens when you create a Deployment using kubectl apply?

### What is the difference between ClusterIP, NodePort, and LoadBalancer Service?

### How does a Pod access AWS S3 securely?

“After creating the IAM policy and IAM role with the EKS OIDC trust relationship, we attach the policy to the role. Then we create a Kubernetes ServiceAccount and associate the IAM Role ARN with it. This mechanism is called IRSA (IAM Roles for Service Accounts). Finally, we configure the Pod to use that ServiceAccount.”

### What is the difference between Deployment and StatefulSet? *

### What is HPA, and how does it work? *

# Prometheus + Grafana — 3

### What is Prometheus, How does Grafana get data and have you create any dashboard in Grafana.

Prometheus is a monitoring tool that collects and stores metrics such as CPU, memory, disk, and application metrics. Grafana does not collect the metrics itself; it reads the metrics from Prometheus and visualizes them.

To create a custom dashboard, I create a new dashboard in Grafana, add a panel, select Prometheus as the data source, use a PromQL query to fetch the required metric such as CPU utilization, select the required visualization, and save the dashboard. We can also import an existing Grafana dashboard using a JSON configuration.

# Ansible — 2


### What is an Ansible Playbook, and why do we use it?

Ansible Playbook is a YAML file where we define the tasks and configuration that need to be performed on managed nodes. We create and run the playbook from the controller node, and Ansible executes those tasks on the managed nodes. We use playbooks to automate and manage multiple tasks in a consistent and repeatable way.


### What is the difference between an Ansible Playbook and an Ad-hoc command?

Ansible Playbook is a YAML file where we define tasks to perform on managed nodes. An ad-hoc command is used to perform a quick task directly from the command line without creating a playbook.
