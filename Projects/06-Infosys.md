# Infosys Interview Questions (AWS)

## What is the difference between Launch Templates and Launch Configurations in Auto Scaling Groups?

Both Launch Template and Launch Configuration are used with Auto Scaling Group to define EC2 instance configuration like AMI, instance type, security group, key pair and other settings.

Launch Configuration is the older method and it does not support versioning. Launch Template is the latest recommended option and it supports multiple versions, which helps us manage changes easily and perform instance updates.

---

## How does an Application Load Balancer differ from a Network Load Balancer? When would you use each?

ALB works at Layer 7 and is mainly used for HTTP/HTTPS applications with features like path-based and host-based routing.

NLB works at Layer 4 and is used for TCP/UDP traffic where we need high performance and low latency.

---

## How do you securely manage application secrets in AWS?

For securely managing application secrets, we should not store passwords or keys in application code or configuration files.

We can use AWS Secrets Manager or SSM Parameter Store to store secrets securely. We can provide access to applications using IAM Roles and apply rotation policies for sensitive secrets.

In my organisation, we use Vault for storing secrets.

---

## Explain IAM Roles, Policies, and Cross-Account Role Assumption with a real-world example.

IAM Role is used to provide permissions to AWS services without using access keys.

For example, if an EC2 instance needs to access S3, we attach an IAM Role to EC2 instead of storing access keys.

IAM Policy defines what actions a user or service can perform on AWS resources.

For example, we can create a policy to allow EC2 start and stop actions.

For cross-account access, we create an IAM Role in the target account and allow the trusted account to assume that role.

Using STS AssumeRole, the user gets temporary credentials to access resources in another AWS account.

---

## How do you monitor AWS infrastructure using CloudWatch? What metrics and alarms do you configure?

We use CloudWatch for monitoring AWS resources and SNS for notifications.

For example, if we want to monitor EC2 CPU utilization, we create a CloudWatch alarm on the CPU metric. If CPU utilization goes above 80%, the alarm triggers and sends notifications through SNS.

For OS-level metrics like memory and disk utilization, we install the CloudWatch Agent on the EC2 instance.

We attach the required IAM role, configure the agent configuration file, and start the agent.

After metrics are available in CloudWatch, we create alarms for memory and disk utilization.

---

## How do you optimize AWS costs for EC2, EKS, S3, and RDS?

For cost optimization, first I will make sure we are using only required resources and right-size the resources based on CPU, memory and usage.

For EC2, we can use Reserved Instances or Savings Plans for long-running workloads and Spot Instances for testing or non-critical workloads.

We should also remove unused volumes and resources.

For S3, we can use Lifecycle Policies to move old data to cheaper storage classes like Glacier.

For RDS, we can select the proper instance size, use reserved pricing for long-term usage and clean up unused snapshots.

---

## What happens when an EC2 instance in an Auto Scaling Group becomes unhealthy?

When an EC2 instance in an Auto Scaling Group becomes unhealthy, first ASG checks the health status after the Health Check Grace Period.

If the instance is still unhealthy, ASG terminates the unhealthy instance and launches a new EC2 instance using the Launch Template.

The new instance is automatically registered with the Target Group and starts receiving traffic.

---

## Describe a major production incident you handled. What was the root cause, and how did you resolve it?

During my night shift, we suddenly received alerts that more than 100 physical servers were showing as Host Down.

I verified the issue by checking router connectivity and attempting SSH access to multiple servers.

Since both router ping and SSH failed, I suspected a Data Center level issue.

I immediately created a Microsoft Teams Incident Bridge, informed the client, and shared all troubleshooting details.

Then I contacted the Equinix Data Center team.

After investigation, they confirmed a PDU failure.

Once the PDU issue was resolved, all servers gradually became reachable.

Finally, we verified server health, updated the incident ticket, and prepared the RCA.

---

## How do you secure an S3 bucket?

To secure an S3 bucket, first I will enable Block Public Access to prevent unauthorized public access.

I will use IAM policies and bucket policies to provide least privilege access.

I will enable encryption using SSE-S3 or SSE-KMS for data protection.

I will enable versioning to protect against accidental deletion and use CloudTrail or access logs for monitoring bucket activity.


# Which AWS services do you use for security and vulnerability management?

# How can you create five empty files and add some content only to the third file using a single Linux command?

# What is the difference between gp2 and gp3 EBS volumes?

# What are the different ways an EC2 instance can access an S3 bucket?

# How would you transfer data from an EC2 instance to an S3 bucket?

# Write a Terraform configuration to create five EC2 instances. If you need to delete only the 1st and 5th instances, how would you do it?

# How can you pause a running Docker container for 5 minutes without using the docker stop command? How would you achieve similar behavior in Kubernetes?

# What resources/specifications do you get with a t2.micro EC2 instance?

# While launching an EC2 instance, what processor/CPU architecture options are available?

# What is the default monitoring interval in CloudWatch, and how does it differ with Detailed Monitoring?

# You have an existing database server. How would you bring it under Terraform management?

# How can you reduce the size of a Docker image?
