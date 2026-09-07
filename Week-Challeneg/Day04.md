# 🔥 Day 4 Question Set

# Git — 3

### What is a Pull Request (PR), and why do we use it?

“Once the developer makes the changes and successfully tests the application, we create a Pull Request to merge the changes into the main branch. The PR is reviewed and approved by the authorized person, and then it is merged into the main branch.”

### What is the difference between git reset and git revert?

“Both are used to undo changes. If the commit is already pushed to the remote repository, I prefer git revert because it creates a new commit to undo the changes. If the commit is local and not pushed, I can use git reset to remove the commit.”

### What is git cherry-pick, and when would you use it?

“Git cherry-pick is used to pick a particular commit from another branch and apply it to the current branch. For example, if there are multiple commits in another branch but I need only one specific commit in the main branch, I can use cherry-pick.”

# AWS + Linux — 5

### What is an IAM Policy, and how is it different from an IAM Role?

“An IAM Policy defines permissions in AWS. There are AWS Managed, Customer Managed, and Inline policies. We can attach a policy to an IAM Role, and then whoever assumes that role gets the permissions defined in the policy.”

### How would you troubleshoot an EC2 instance if it is running but has become unreachable?

“If an EC2 instance is running but unreachable, first I will check the EC2 status checks to confirm 2/2 are passing. Then I will check the Security Group and NACL for any blocked traffic. After that, I will check the Route Table and Internet Gateway if it is a public instance. Then I will check whether the required port is listening and whether the service is running. Finally, I will check the system and application logs to identify the issue and resolve it.”

### What is the difference between an Internet Gateway and a NAT Gateway?

“Internet Gateway is used to provide internet connectivity to resources in a public subnet. NAT Gateway is used to provide outbound internet access to resources in a private subnet, for example to download packages or updates, while the resources are not directly accessible from the internet.”

### How would you troubleshoot high memory utilization on a Linux server? ⭐ Repeat

I know it

### How would you check which process is listening on a particular port in Linux?

ss -tulnp | grep :80

# Docker — 3

### What is a Docker Registry, and why do we use it?

“A Docker Registry is used to store, push, and pull Docker images. It provides a centralized location from where images can be stored and retrieved.”

### How do Docker containers communicate with each other?

I know it

### What is the difference between docker stop and docker kill?

“docker stop gracefully stops a container by giving the application time to shut down properly, while docker kill forcefully stops the container immediately without giving the application time for graceful cleanup.”

# Terraform — 5

### What is depends_on in Terraform, and when do you use it?

“depends_on is used to explicitly define a dependency between resources. It tells Terraform to create one resource first and then create the dependent resource. We use it when Terraform cannot automatically detect the dependency.”

### What is the difference between a Terraform resource and a data source?

“A Terraform resource is used to create and manage infrastructure, such as EC2, S3, or VPC. A data source is used to fetch information about an existing resource that is not managed by Terraform. For example, we can use a data source to get the AMI ID that we want to use for an EC2 instance.”

### What are Terraform output values, and why do we use them?

“Terraform output values are used to display or expose important information about the resources after they are created. We define them using an output block. For example, we can use an output to get the EC2 instance ID, public IP, or load balancer DNS name.”

### What is Terraform drift, and how would you handle it?

“Terraform drift is a difference between the Terraform state and the actual infrastructure. For example, if Terraform created an EC2 instance as t2.micro and someone manually changes it to t3.medium, Terraform can detect the difference during terraform plan. To handle drift, I first identify which resource has drifted, investigate whether the change was planned or unplanned, and then take the appropriate action after approval.”

### What is the purpose of the .terraform.lock.hcl file?

“.terraform.lock.hcl is used to lock the provider versions and checksums so that Terraform uses the same provider versions consistently across environments.”

# Jenkins — 3

### What is the difference between a Jenkins Freestyle job and a Pipeline?

“Freestyle is mainly used for simple jobs and we configure it from the UI, while Jenkins Pipeline is used to automate a complete CI/CD workflow with multiple stages, and we can define it as code in a Jenkinsfile.”

### How does Jenkins handle credentials securely?

“Jenkins provides a Credentials Manager where we can securely store credentials such as passwords, secret keys, SSH private keys, and tokens. We then use the credential ID in the pipeline instead of hardcoding the credentials.”

### What would you check if a Jenkins pipeline suddenly starts failing?

I know it

# Kubernetes — 5

### What is a Namespace in Kubernetes, and why do we use it?

“A Namespace provides logical isolation for Kubernetes resources within the same cluster.

### What is the difference between a Pod and a container?

“A Pod is the smallest deployable unit in Kubernetes, and it can contain one or more containers. The container runs the application inside the Pod.”

### Your Kubernetes Deployment is successfully created, but users are getting a 503 error and cannot access the application. How would you troubleshoot it? 

“If the Deployment is successful but users are getting 503, first I will check the Ingress and Ingress Controller. Then I will verify that the Ingress is pointing to the correct Service and port. After that, I will check the Service endpoints and make sure healthy Pods are available. I will also check the readiness probe because a Pod can be running but not Ready, so the Service will not send traffic to it. Finally, I will check the Pod and Ingress Controller logs to identify the root cause.”

### A Pod is repeatedly crashing after deployment. How would you troubleshoot the issue? 

“First, I will identify the Pod that is crashing. Then I will check the current and previous logs and use kubectl describe pod to check the exact error and events. I will check common causes such as application errors, probes, configuration issues, resource problems, or image issues. Based on the root cause, I will fix the issue and verify that the Pod becomes stable.”

### What is a PersistentVolumeClaim (PVC), and how does it relate to a PersistentVolume (PV)?

“A PersistentVolume (PV) provides storage in Kubernetes, while a PersistentVolumeClaim (PVC) is a request to claim a specific amount of storage from the available PV.”

# ITIL — 3

### What is an Incident in ITIL, and how is it different from a Problem?

“An Incident is an issue that is happening now and affecting the service. Our goal is to restore the service quickly. A Problem is the reason behind the incident. We investigate the problem to find the root cause and prevent the incident from happening again.”

### What is a Service Request, and how is it different from an Incident?

“A Service Request is a user request for a standard service, such as installing an application, providing access, or requesting new hardware. Unlike an Incident, it is not related to a service failure or issue.”

### What is an SLA, and why is it important in IT support?

“SLA stands for Service Level Agreement. It defines the agreed response and resolution time for an issue or service request. It is important because it helps us meet the agreed service commitments with the customer.”

# Ansible — 2

### What is an Ansible Inventory, and why is it required?

“Ansible Inventory is a file where we define the managed nodes or servers on which Ansible needs to perform tasks. It can also group the servers based on their roles or environments.”

### How do you run an Ansible Playbook against specific managed nodes?

“I will create an Ansible Playbook in YAML, define the required tasks, and specify the target hosts or host group from the inventory. Then I will run the playbook using the ansible-playbook command.”
