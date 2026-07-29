# ☁️ AWS Basic Interview Questions

---

# Q1. What is AWS?

## Answer

AWS (Amazon Web Services) is a cloud computing platform provided by Amazon.

It provides services like Compute, Storage, Database, Networking, Security and Monitoring.

Instead of purchasing and maintaining physical servers, we can launch resources on AWS within a few minutes and pay only for what we use.

---

# Q2. What are the benefits of AWS?

## Answer

Some important benefits of AWS are:

- Pay As You Go pricing.
- High Availability.
- Scalability.
- Global Infrastructure.
- Better Security.
- Managed Services.
- Easy Backup and Disaster Recovery.

---

# Q3. What is Cloud Computing?

## Answer

Cloud Computing means delivering IT resources like servers, storage, networking and databases over the internet instead of maintaining physical infrastructure.

Users can create or remove resources whenever required and pay only for what they use.

---

# Q4. What are the types of Cloud?

## Answer

There are three types of Cloud.

### Public Cloud

Resources are owned and managed by the cloud provider.

Example:

AWS, Azure, GCP.

---

### Private Cloud

Resources are dedicated to a single organization.

Example:

VMware, OpenStack.

---

### Hybrid Cloud

Combination of Public Cloud and Private Cloud.

Some workloads remain on-premises and others run on the cloud.

---

# Q5. What are the Cloud Service Models?

## Answer

There are three cloud service models.

### IaaS

Infrastructure as a Service.

AWS provides virtual machines, storage and networking.

Example:

EC2

EBS

VPC

---

### PaaS

Platform as a Service.

AWS manages the operating system and runtime.

Example:

Elastic Beanstalk.

---

### SaaS

Software as a Service.

Complete application is managed by the provider.

Example:

Gmail

Microsoft 365

Salesforce

---

# Q6. Explain AWS Global Infrastructure.

## Answer

AWS Global Infrastructure consists of:

- Regions
- Availability Zones
- Edge Locations

A Region is a geographical location.

Each Region contains multiple Availability Zones.

Availability Zones are isolated data centers connected with low latency.

Edge Locations are used to deliver content faster using CloudFront.

---

# Q7. What is an AWS Region?

## Answer

A Region is a geographical area where AWS has multiple Availability Zones.

Example:

Mumbai

Singapore

Ohio

London

When creating AWS resources, we select the required Region based on business requirements.

---

# Q8. What is an Availability Zone?

## Answer

An Availability Zone is one or more physically separate data centers within a Region.

Each Availability Zone has independent power, cooling and networking.

Deploying applications across multiple Availability Zones improves High Availability.

---

# Q9. What is an Edge Location?

## Answer

Edge Locations are used by CloudFront to cache content closer to end users.

This helps reduce latency and improves application performance.

---

# Q10. Explain the AWS Shared Responsibility Model.

## Answer

AWS follows the Shared Responsibility Model.

AWS is responsible for the security **of the Cloud**.

Examples:

- Physical Security
- Hardware
- Networking
- Data Centers

The customer is responsible for security **in the Cloud**.

Examples:

- IAM Users
- Security Groups
- Operating System
- Application
- Data
- Encryption
- Patching

---

# Q11. Why do companies move from On-Premises to AWS?

## Answer

Companies move from On-Premises to AWS because AWS is more flexible and cost-effective.

In an on-premises environment, the company has to purchase and maintain physical servers, storage, and networking, which takes both time and money.

In AWS, we can launch resources within a few minutes and pay only for what we use.

AWS also provides High Availability, easy scalability, better security, and backup and disaster recovery options.

Overall, AWS helps companies reduce infrastructure costs, improve availability, and manage resources more efficiently.

---

# Q12. How do you access AWS resources?

## Answer

We can access AWS resources in different ways.

The most common way is the AWS Management Console, which is a web-based interface.

We can also use the AWS CLI to manage resources from the command line.

For automation, developers use AWS SDKs, and applications communicate with AWS services through APIs.

In my day-to-day work, I mainly use the AWS Management Console for monitoring and troubleshooting, and occasionally the AWS CLI for basic operations.

---

# Q13. What is AWS CLI?

## Answer

AWS CLI is a command-line tool used to manage AWS services from the terminal.

It helps automate tasks and manage resources using commands.

---

# Q14. What is the difference between a Region and an Availability Zone?

## Answer

A Region is a geographical location where AWS provides its cloud services, for example Mumbai, Singapore, or London.

An Availability Zone is one or more isolated data centers within a Region.

A Region contains multiple Availability Zones.

We deploy applications across multiple Availability Zones to achieve High Availability. If one Availability Zone goes down, the application can continue running from another Availability Zone.


# Q15. Which AWS services have you worked on?

## Answer

I have mainly worked on EC2, EBS, S3, IAM, VPC, and CloudWatch.

My day-to-day responsibilities include monitoring EC2 instances, troubleshooting Linux server issues, extending EBS volumes, managing IAM users and policies, uploading files to S3, and monitoring infrastructure using CloudWatch.

I also coordinate with the Application, Network, and Cloud teams to resolve production incidents and ensure services are running smoothly.
