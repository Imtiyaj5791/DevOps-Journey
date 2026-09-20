# 🔥 Day 6 Question Set

### 1 Can you define your infrastructure? How is your application infrastructure designed from end to end?

Our infrastructure is hosted on AWS. We have a VPC with public and private subnets. Application traffic comes through the load balancer 
and is routed to the application servers or containers. The application uses a database and other AWS services as required. 
We provision the infrastructure using Terraform, and use Git and Jenkins for CI/CD, Docker for containerization, and ECR for storing images. 
We use IAM and Security Groups for access control, and CloudWatch and Grafana for monitoring and alerting.


### 2 How would you design highly available infrastructure on AWS?

I would design the infrastructure across multiple Availability Zones using ALB and Auto Scaling to avoid single points of failure.
I would use Multi-AZ for the database and health checks for automatic recovery. I would provision and manage this infrastructure using Terraform, 
use CI/CD for controlled deployments, and use CloudWatch and Grafana for monitoring and alerting.

### 3 How do you secure your AWS infrastructure?

I will use IAM with least-privilege access, and SCP to control permissions at the organization level. For network security, 
I will use Security Groups and NACLs and allow only required ports. I will use KMS for encryption and Secrets Manager for passwords and sensitive information.
AWS Config can be used to check resource configurations and compliance, and GuardDuty can be used for threat detection.
I can use Amazon Inspector to identify vulnerabilities in EC2 and container images. CloudTrail will be used for auditing and CloudWatch for monitoring and alerting.

### 4 How do you optimize and control AWS costs in your infrastructure?

I will choose the right instance type based on the workload. For long-term workloads, I can use Reserved Instances or Savings Plans, 
and for short-term or fault-tolerant workloads, I can use Spot Instances. I will identify and remove unused EBS volumes, old snapshots,
unused Elastic IPs and other resources after approval. I will also move logs and suitable data to S3 and configure lifecycle policies to reduce storage costs.

### 5 How do you securely store and manage passwords, API keys, and other sensitive information in a DevOps environment?

I will never hardcode passwords, tokens, API keys, or registry credentials in Git, Dockerfiles, Jenkinsfiles, or configuration files. For GitHub, 
I will use SSH keys or tokens securely, and Jenkins credentials will be stored in Jenkins Credentials Manager. For AWS and ECR, I will prefer IAM roles
and least-privilege permissions instead of long-lived access keys. For application passwords and API keys, I will use AWS Secrets Manager, and for Kubernetes 
I can use Kubernetes Secrets or integrate with AWS Secrets Manager. I will also follow least privilege and rotate credentials when required.

### 6 How do you secure Docker containers and Docker images in a production environment?

For Docker security, I will use a trusted and minimal base image and scan the image using Trivy. I will not keep any password or secret inside the Dockerfile or image.
I will run the container as a normal user instead of root and expose only the required ports. 
I will store the images in a private registry like ECR and give only required access

### 7 How do you secure your CI/CD pipeline?

I will secure the CI/CD pipeline by storing credentials in Jenkins Credentials Manager. I will use SonarQube for code quality and security checks, and Trivy for image
vulnerability scanning. I will also use proper access permissions in Jenkins and IAM roles for AWS access.

### 8 How do you secure Kubernetes/EKS?

For Kubernetes or EKS security, I will use RBAC to give users and applications only required permissions. For AWS access, 
I will use IAM roles instead of storing access keys inside pods. I will use Kubernetes Secrets or AWS Secrets Manager for sensitive information. 
I will also restrict unnecessary network communication between pods.

### 9 What will you do if a password or secret is accidentally leaked in Git?

First, I will revoke or rotate the leaked secret. Then I will remove it from Git and check if it was used anywhere. After that, 
I will update the application with the new secret and document the incident.

### 10 How do you handle a critical/high vulnerability found by Trivy in a production Docker image?

If Trivy finds a high or critical vulnerability, I will first check the vulnerable package and its impact. I will update the package or base image, scan the image 
again, and deploy only after the vulnerability is resolved or an approved risk decision is taken.

### 11 How do you make an AWS application highly available if one Availability Zone goes down?

I will deploy the application in multiple Availability Zones. I will use an Application Load Balancer to distribute traffic between them and Auto Scaling to maintain 
the required instances. If one Availability Zone goes down, traffic can be served from the other Availability Zone.

### 12 How do you secure a production deployment?

For production deployment, I will first test and scan the changes. I will follow the required approval or change process before deployment. After deployment, 
I will verify the application health and monitor it. If there is a major issue, I will rollback the change.

### 13 What will you do if an AWS access key is accidentally exposed?

If an AWS access key is exposed, I will immediately disable the key and check CloudTrail for any unauthorized activity. 
Then I will replace the credential where required and update the application or pipeline. Where possible, I will use an IAM Role instead of long-lived access keys.

### 14 How do you secure communication between users and your application?

I will use HTTPS for communication between users and the application. I will configure an SSL/TLS certificate on the load balancer so that data is encrypted 
while it is travelling between the user and the application.

### 15 Production application is suddenly down, and you suspect a security issue. What will you do?

“First, I will check the impact and confirm the issue. Then I will check monitoring, logs, and security alerts to find the cause. If a security issue is confirmed, 
I will restrict the affected access and inform the security team. After that, I will restore the application using the approved recovery process and perform RCA.





