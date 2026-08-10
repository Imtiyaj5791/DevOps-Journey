# ⚡ AWS Lambda + Systems Manager (SSM) – Top 30 Interview Questions

> **Level:** AWS Cloud / Linux Support – L2  
> **Focus:** Lambda Basics + Event-Driven Automation + IAM + Troubleshooting + SSM Agent + Session Manager + Run Command + Patch Manager + Parameter Store

---

# Q1. What is AWS Lambda?

## Answer

AWS Lambda is a serverless compute service used to run code without managing servers.

AWS manages the underlying infrastructure and we only provide the function code.

Example:

```text
Event
  ↓
Lambda Function
  ↓
Execute Code
```

**Remember:**

`Lambda = Run Code Without Managing Server`

---

# Q2. Why do we use Lambda?

## Answer

Lambda is mainly used for automation and event-driven tasks.

Examples:

- Start or stop EC2 instances
- Process S3 events
- Trigger actions from SNS
- Run scheduled tasks using EventBridge
- Automate small operational tasks

---

# Q3. What is a Lambda Function?

## Answer

A Lambda Function is the actual code or task created inside AWS Lambda.

Example:

```text
Lambda Service
    |
    |-- Start-EC2 Function
    |
    |-- Stop-EC2 Function
```

---

# Q4. What is Runtime in Lambda?

## Answer

Runtime defines which programming language is used to execute the Lambda function.

Examples:

```text
Python
Node.js
Java
```

In our lab, we used Python-based Lambda understanding for EC2 start/stop automation.

---

# Q5. What is a Lambda Handler?

## Answer

Handler is the entry point of the Lambda function.

When Lambda is triggered, execution starts from the handler.

Example:

```python
def lambda_handler(event, context):
```

**Remember:**

`Handler = Lambda Code Entry Point`

---

# Q6. What is a Lambda Trigger?

## Answer

A trigger is an event or AWS service which invokes a Lambda function.

Common examples:

- EventBridge
- S3
- SNS
- SQS
- API Gateway

Example:

```text
EventBridge
    ↓
Lambda
    ↓
EC2 Stop
```

---

# Q7. Why does Lambda need an IAM Role?

## Answer

Lambda needs permission to perform actions on other AWS services.

For example, if Lambda needs to stop an EC2 instance, the Lambda execution role must have permission to stop EC2 instances.

**Flow:**

```text
Lambda
  ↓
IAM Role
  ↓
Required Permission
  ↓
AWS Resource
```

---

# Q8. What is a Lambda Execution Role?

## Answer

Lambda Execution Role is an IAM Role assumed by the Lambda function.

It provides permissions required by the function.

For example:

```text
Lambda
  ↓
Execution Role
  ↓
EC2 Stop Permission
```

---

# Q9. What is Lambda Timeout?

## Answer

Timeout defines how long a Lambda function is allowed to run.

If execution takes longer than the configured timeout, Lambda stops the function.

Maximum Lambda timeout is:

```text
15 Minutes
```

---

# Q10. What are Environment Variables in Lambda?

## Answer

Environment Variables are used to store configuration values outside the Lambda code.

Example:

```text
INSTANCE_ID = i-xxxxxxxx
ENV = production
```

Sensitive values like passwords should preferably be stored in services such as Secrets Manager or SSM Parameter Store instead of hard-coding them.

---

# Q11. How can Lambda automatically stop an EC2 instance?

## Answer

We can create a Lambda function with EC2 stop logic.

Then we attach an IAM Role with required EC2 permissions.

After testing the function, we can use EventBridge to trigger it on a schedule.

**Flow:**

```text
EventBridge Schedule
        ↓
Lambda Function
        ↓
IAM Role
        ↓
EC2 Stop
```

---

# Q12. What is the difference between Lambda and EventBridge?

## Answer

Lambda runs the code.

EventBridge triggers the Lambda function based on a schedule or event.

**Remember:**

```text
EventBridge = When to Run

Lambda = What Code to Run
```

---

# Q13. Lambda function is not stopping EC2. How will you troubleshoot?

## Answer

First I will check the Lambda execution result and CloudWatch Logs.

Then I will check:

- Lambda execution role
- EC2 permissions
- Correct Instance ID
- Correct Region
- Function code
- Lambda timeout

If the error is permission-related, I will verify the IAM policy attached to the Lambda execution role.

---

# Q14. Lambda is getting AccessDenied error. What will you check?

## Answer

First I will check the Lambda execution role.

Then I will verify whether the role has the required permission for the AWS action.

For example, for EC2 stop operation, the role needs permission for the required EC2 API action.

**Remember:**

`AccessDenied → Check IAM Role / Permission`

---

# Q15. Lambda function is failing. Where will you check logs?

## Answer

Lambda execution logs are commonly available in CloudWatch Logs when the execution role and logging configuration allow it.

I will check the relevant Lambda log group in CloudWatch Logs and identify the exact error.

**Troubleshooting Flow:**

```text
Lambda Failure
    ↓
CloudWatch Logs
    ↓
Exact Error
    ↓
IAM / Code / Config / Timeout
```

---

# Q16. What is AWS Systems Manager?

## Answer

AWS Systems Manager is used to centrally manage and operate EC2 instances and other managed servers.

The important SSM features we covered are:

- Session Manager
- Run Command
- Patch Manager
- Parameter Store

**Remember:**

```text
Session Manager = Remote Access

Run Command = Remote Command Execution

Patch Manager = OS Patching

Parameter Store = Store Configuration / Sensitive Values
```

---

# Q17. What is SSM Agent?

## Answer

SSM Agent is software installed and running on the server.

It allows AWS Systems Manager to communicate with and manage the instance.

**Remember:**

```text
SSM Agent = Communication
IAM Role = Permission
```

---

# Q18. How do you check SSM Agent on Ubuntu?

## Answer

To check whether SSM Agent is installed:

```bash
snap list amazon-ssm-agent
```

To check whether it is running:

```bash
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
```

Expected status:

```text
active (running)
```

---

# Q19. What IAM permission is commonly required for EC2 to work with Systems Manager?

## Answer

The EC2 instance needs an IAM Role with required Systems Manager permissions.

A commonly used AWS managed policy is:

```text
AmazonSSMManagedInstanceCore
```

**Remember:**

```text
SSM Agent = Communication

AmazonSSMManagedInstanceCore = Common SSM Permission Policy
```

---

# Q20. What is Session Manager?

## Answer

Session Manager is an SSM feature used to remotely access an EC2 instance without using a PEM key and without opening inbound SSH port 22.

Example:

```text
AWS Console
    ↓
Session Manager
    ↓
SSM Agent
    ↓
EC2
```

---

# Q21. What are the requirements for Session Manager?

## Answer

The main requirements are:

- SSM Agent installed and running
- EC2 IAM Role with required SSM permissions
- Network connectivity from the instance to Systems Manager endpoints

A private EC2 can also use Session Manager if it has the required connectivity through NAT or supported VPC endpoints.

---

# Q22. Session Manager is not showing my EC2 instance. How will you troubleshoot?

## Answer

First I will check whether SSM Agent is installed and running.

Then I will check:

- IAM Role attached to EC2
- Required SSM permissions
- Network connectivity
- Correct AWS Region
- SSM Agent logs

I will also wait a few minutes if the IAM Role was attached recently.

**Troubleshooting Flow:**

```text
SSM Agent
    ↓
IAM Role
    ↓
Network Connectivity
    ↓
Region
    ↓
Agent Logs
```

---

# Q23. What is Run Command?

## Answer

Run Command is an SSM feature used to remotely execute commands or scripts on one or multiple managed instances without manually logging into each server.

Example:

```text
Run Command
    ↓
df -h
    ↓
Multiple EC2 Instances
    ↓
Output
```

---

# Q24. How did we use Run Command in the lab?

## Answer

We opened:

```text
Systems Manager
→ Run Command
→ Run command
```

Then we selected:

```text
AWS-RunShellScript
```

We entered:

```bash
df -h
```

Then we selected our EC2 instance as the target.

The disk utilization output was returned in Systems Manager.

This proved that we could execute a command remotely without manually logging in to the server.

---

# Q25. Run Command is failing on an EC2 instance. What will you check?

## Answer

First I will check whether the instance is managed by Systems Manager.

Then I will check:

- SSM Agent status
- IAM Role
- Network connectivity
- Command document
- Command output/error
- Required OS permissions

If the command itself is incorrect, I will correct the command based on the error output.

---

# Q26. What is SSM Patch Manager?

## Answer

Patch Manager is an SSM feature used to centrally scan and install operating system patches on managed servers.

It also helps us check patch compliance.

**Basic Flow:**

```text
Scan
 ↓
Check Compliance
 ↓
Install Patches
 ↓
Reboot if Required
 ↓
Re-scan
 ↓
Verify Compliance
```

---

# Q27. What is the difference between Scan and Scan and Install?

## Answer

### Scan

Only checks for missing patches.

It does not install patches.

### Scan and Install

Checks for patches and installs approved/applicable patches.

**Remember:**

```text
Scan = Check Only

Scan and Install = Check + Install
```

---

# Q28. Patch Manager scan succeeded but Compliance shows Non-compliant. What does it mean?

## Answer

It means the scan completed successfully, but the instance does not meet the required patch compliance state.

In our lab, this indicated that required patches were missing.

Example:

```text
Scan = Succeeded

Compliance = Non-compliant
```

This is not a scan failure.

It means patching or further review is required.

---

# Q29. How did we validate patching after installation?

## Answer

After patch installation, we ran another Patch Manager Scan.

Before patching:

```text
Nodes with missing patches = 1
```

After patching and re-scan:

```text
Nodes with missing patches = 0
Nodes with failed patches = 0
Nodes pending reboot = 0
Available security updates = 0
```

This confirmed that the required patching was successful.

**Remember:**

`Patch → Re-scan → Verify Compliance`

---

# Q30. What is SSM Parameter Store?

## Answer

Parameter Store is used to centrally store configuration values and sensitive information instead of hard-coding them inside application code.

Examples:

```text
DB Host
DB Port
DB Password
API Key
Environment Name
```

For sensitive values such as DB password, we can use:

```text
SecureString
```

SecureString uses KMS encryption.

---

# ⭐ Frequently Asked Cross Questions

### Q1. What is the difference between String and SecureString in Parameter Store?

**Answer:**

```text
String
= Normal configuration value

SecureString
= Sensitive value protected using KMS encryption
```

Example:

```text
DB_HOST
→ String

DB_PASSWORD
→ SecureString
```

---

### Q2. How can an EC2 instance retrieve a SecureString parameter?

**Answer:**

The EC2 identity needs the required permissions.

Using AWS CLI, we can retrieve a parameter with decryption.

Example:

```bash
aws ssm get-parameter \
--name "/myapp/db-password" \
--with-decryption
```

---

### Q3. If an EC2 IAM Role can access the DB password, can a user logged into that EC2 retrieve it?

**Answer:**

If the user has sufficient shell access to the server and the server's IAM Role is allowed to retrieve/decrypt that parameter, the user may also be able to retrieve the value.

This is why server access and IAM permissions should also be tightly controlled.

---

### Q4. What is the main benefit of Parameter Store?

**Answer:**

The main benefits are:

- Avoid hard-coding configuration/secrets
- Centralized storage
- IAM-controlled access
- KMS encryption for SecureString

---

### Q5. Does Session Manager use SSH port 22?

**Answer:**

No.

Session Manager does not require inbound SSH port 22 for the Session Manager connection.

---

### Q6. Can SSM work with a private EC2 instance?

**Answer:**

Yes.

The instance needs connectivity to the required Systems Manager endpoints, either through appropriate outbound connectivity or supported VPC endpoints.

---

### Q7. What if SSM Agent is not installed on a private EC2 and there is no internet access?

**Answer:**

The agent cannot simply be downloaded from an internet repository without network access.

Possible options include:

- Temporary outbound connectivity
- Internal package repository
- Existing Bastion/VPN/admin access
- Custom AMI with SSM Agent pre-installed

---

### Q8. What happened when we tried Patch Manager on Ubuntu 26.04?

**Answer:**

The Patch Manager operation failed with:

```text
UnsupportedOperatingSystem
```

SSM Agent and IAM were working because Session Manager and Run Command were successful.

We then used Ubuntu 24.04 for the Patch Manager lab and the scan/patching completed successfully.

---

### Q9. What is the difference between Session Manager and Run Command?

**Answer:**

```text
Session Manager
= Remotely log in to the server

Run Command
= Execute command remotely without manually logging in
```

---

### Q10. How would you explain SSM in one answer?

**Answer:**

AWS Systems Manager is used to centrally manage EC2 instances and other managed servers.

We can use Session Manager for remote access, Run Command for remote command execution, Patch Manager for OS patching and compliance, and Parameter Store for storing configuration and sensitive values.

---

# 🔥 Lambda Complete Flow

```text
Event / Schedule
      ↓
EventBridge / Other Trigger
      ↓
Lambda Function
      ↓
IAM Execution Role
      ↓
AWS Resource
      ↓
Action Performed
```

---

# 🔥 SSM Session Manager Flow

```text
AWS Console
    ↓
Session Manager
    ↓
SSM Agent
    ↓
EC2 Instance
```

---

# 🔥 SSM Run Command Flow

```text
Systems Manager
      ↓
Run Command
      ↓
AWS-RunShellScript
      ↓
Target EC2
      ↓
Command Execution
      ↓
Output
```

---

# 🔥 Patch Manager Flow

```text
Managed EC2
    ↓
Patch Scan
    ↓
Compliance
    ↓
Non-compliant
    ↓
Scan and Install
    ↓
Reboot if Required
    ↓
Re-scan
    ↓
Verify Missing Patches = 0
```

---

# 🔥 Parameter Store Flow

```text
Application / EC2
       ↓
IAM Permission
       ↓
Parameter Store
       ↓
SecureString
       ↓
KMS Decryption
       ↓
Application Uses Value
```

---

# 🔥 Final Quick Revision

```text
Lambda
= Serverless Compute

Lambda Function
= Actual Code / Task

Runtime
= Programming Language

Handler
= Code Entry Point

Trigger
= Invokes Lambda

EventBridge
= Schedule / Event Trigger

Lambda IAM Role
= Permission for AWS Actions

Timeout
= Maximum Runtime Limit

SSM
= Central Server Management

SSM Agent
= Communication Between Server and Systems Manager

AmazonSSMManagedInstanceCore
= Common SSM Managed Policy

Session Manager
= Remote Access Without Inbound SSH Port 22

Run Command
= Remote Command Execution

Patch Manager
= Scan + Install + Compliance

Scan
= Check Only

Non-compliant
= Patch Compliance Issue / Missing Required Patches

Re-scan
= Post-Patching Validation

Parameter Store
= Central Configuration Storage

String
= Normal Value

SecureString
= Sensitive Value + KMS Encryption

CloudWatch Logs
= Common Place to Check Lambda Execution Logs
```
