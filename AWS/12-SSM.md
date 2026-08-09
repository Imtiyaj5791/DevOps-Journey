# AWS Systems Manager (SSM)

## What is AWS Systems Manager?

AWS Systems Manager is an AWS service which is used to centrally manage and operate EC2 instances and other managed servers.

The main SSM features we covered are:

- Session Manager
- Run Command
- Patch Manager
- Parameter Store

Simple way to remember:

```text
Session Manager  → Remote access
Run Command      → Remote command execution
Patch Manager    → OS patching
Parameter Store  → Store configuration/secrets
```

---

## What is SSM Agent?

SSM Agent is software installed and running on the EC2 instance.

It allows the EC2 instance to communicate with AWS Systems Manager.

Simple concept:

```text
Systems Manager
      |
      v
SSM Agent
      |
      v
EC2 Instance
```

---

## Why does EC2 need an IAM Role for SSM?

SSM Agent provides communication, but EC2 also needs permission to communicate with Systems Manager.

For this, we attach an IAM Role to the EC2 instance.

Simple way to remember:

```text
SSM Agent = Communication
IAM Role  = Permission
```

A commonly used AWS managed policy is:

```text
AmazonSSMManagedInstanceCore
```

---

## How do you check if SSM Agent is installed on Ubuntu?

Run:

```bash
snap list amazon-ssm-agent
```

If `amazon-ssm-agent` appears in the output, SSM Agent is installed.

---

## How do you check if SSM Agent is running?

Run:

```bash
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
```

We can also use:

```bash
sudo snap services amazon-ssm-agent
```

Expected status:

```text
active (running)
```

---

## How do you manually install SSM Agent on Ubuntu?

If SSM Agent is not already installed, we can install it using:

```bash
sudo snap install amazon-ssm-agent --classic
```

Start the agent:

```bash
sudo snap start amazon-ssm-agent
```

Check the status:

```bash
sudo snap services amazon-ssm-agent
```

Many AWS Ubuntu AMIs already have SSM Agent installed.

---

# SSM Session Manager

## What is Session Manager?

Session Manager is an SSM feature which is used to remotely access an EC2 instance without using a PEM key and without opening inbound SSH port 22.

Normal SSH:

```text
Laptop
   |
   v
Port 22 + PEM Key
   |
   v
EC2
```

Session Manager:

```text
AWS Systems Manager
        |
        v
Session Manager
        |
        v
SSM Agent
        |
        v
EC2
```

---

## What are the basic requirements for Session Manager?

The main requirements are:

- SSM Agent should be installed and running.
- EC2 should have the required IAM Role.
- EC2 should have network connectivity to Systems Manager endpoints.

---

## How did we configure Session Manager in the lab?

First, we checked whether SSM Agent was installed.

```bash
snap list amazon-ssm-agent
```

Then we checked its status.

```bash
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
```

The agent was:

```text
active (running)
```

Then we verified that the EC2 instance had an IAM Role with the required SSM permissions.

After that, we opened:

```text
AWS Console
→ Systems Manager
→ Session Manager
→ Start session
```

We selected our EC2 instance and started the session.

The EC2 terminal opened successfully.

---

## How did we verify the Session Manager user?

Inside the Session Manager terminal, we can run:

```bash
whoami
```

The session can use an SSM-created operating system user depending on the Session Manager configuration.

---

## How did we verify that Session Manager does not require port 22?

We removed/disabled SSH port 22 access from the Security Group for the test.

Then we again opened:

```text
Systems Manager
→ Session Manager
→ Start session
```

The EC2 terminal still opened successfully.

This proved that Session Manager does not require inbound SSH port 22.

---

## Does Session Manager require a PEM key?

No.

Session Manager does not require a PEM key for the Session Manager connection.

Access is controlled through AWS IAM and Systems Manager.

---

## What if the EC2 instance is in a private subnet?

A private EC2 instance can also use Systems Manager.

It needs network connectivity to the required Systems Manager endpoints.

This can be provided through outbound connectivity such as NAT or by using the required VPC endpoints.

---

## What if SSM Agent is not installed and the private EC2 has no internet?

If SSM Agent is not installed and the private instance has no internet/NAT access, it cannot simply download the package from an internet repository.

Possible options are:

- Provide temporary outbound connectivity.
- Use an internal package repository.
- Use an existing Bastion/VPN/admin access method to transfer/install the package.
- Use a custom AMI where SSM Agent is already installed.

After SSM Agent is installed, private connectivity to Systems Manager can be provided using the required VPC endpoints.

---

## How would you explain Session Manager in an interview?

Session Manager is an AWS Systems Manager feature used to remotely access EC2 instances without opening inbound SSH port 22 and without using a PEM key.

The EC2 instance should have SSM Agent installed and running, the required IAM Role, and connectivity to Systems Manager.

---

# SSM Run Command

## What is SSM Run Command?

Run Command is an SSM feature which is used to remotely execute commands or scripts on one or multiple managed servers without manually logging into each server.

Simple difference:

```text
Session Manager
→ Login to the server
→ Run commands manually

Run Command
→ No manual server login
→ Send command remotely
→ Command executes on target server
```

---

## Why do we use Run Command?

Suppose we have 100 servers and want to check disk utilization.

Normally, we may have to log in to servers and run:

```bash
df -h
```

Using Run Command, we can send the command remotely to selected managed instances.

This is useful for tasks such as:

- Checking disk utilization
- Checking services
- Restarting services
- Executing scripts
- Running administrative commands
- Installing packages when appropriate

---

## Do we need to specify the server in Run Command?

Yes.

Run Command needs a target.

We can select:

- Individual EC2 instances
- Multiple EC2 instances
- Groups of managed instances using tags

Example:

```text
Run Command
     |
     v
Command = df -h
     |
     v
Target EC2 Instances
     |
     v
Execute
     |
     v
Output
```

---

## What is AWS-RunShellScript?

`AWS-RunShellScript` is an AWS Systems Manager document which can be used to run shell commands on supported Linux managed nodes.

In our lab, we used it to execute:

```bash
df -h
```

---

## How did we perform the Run Command lab?

We opened:

```text
AWS Console
→ Systems Manager
→ Run Command
→ Run command
```

Then we searched for and selected:

```text
AWS-RunShellScript
```

In Command parameters, we entered:

```bash
df -h
```

Then under Targets, we selected:

```text
Choose instances manually
```

We selected our EC2 instance.

After that, we executed the command.

---

## What was the Run Command output in our lab?

The command executed successfully and returned the disk information.

Example:

```text
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         14G  5.0G  8.4G  38% /
```

This proved that the command was executed on EC2 without manually opening an SSH or Session Manager terminal.

---

## What is the difference between a Script and Run Command?

A script defines what task needs to be performed.

Run Command provides a way to remotely execute that command or script on selected managed servers.

Simple way to remember:

```text
Script      = What to execute
Run Command = How to remotely execute it on managed servers
```

---

## How would you explain Run Command in an interview?

Run Command is an AWS Systems Manager feature used to remotely execute commands or scripts on one or multiple managed instances without manually logging into every server.

We specify the command and target instances, and SSM Agent executes the command and returns the result.

---

# SSM Patch Manager

## What is SSM Patch Manager?

Patch Manager is an AWS Systems Manager feature used to centrally scan and install operating system patches on managed servers.

It also helps us check patch compliance.

The patching concept is similar to centralized patch-management tools such as NinjaRMM.

---

## What is the basic Patch Manager flow?

```text
Scan
  |
  v
Check Compliance
  |
  v
Missing Patches?
  |
  v
Review / Approval
  |
  v
Install Patches
  |
  v
Reboot If Required
  |
  v
Re-scan
  |
  v
Validate Compliance
```

---

## What is Scan in Patch Manager?

Scan means Patch Manager checks the server for missing patches.

It does not install the patches.

Simple way to remember:

```text
Scan = Check only
```

---

## What is Scan and Install?

Scan and Install checks for the applicable approved patches and installs them.

Simple way to remember:

```text
Scan             = Check only
Scan and Install = Check + Install
```

---

## What does Non-compliant mean?

Non-compliant means the managed node does not meet the required patch compliance state.

In our lab, after the scan, we found missing patches and the node showed as non-compliant.

Example:

```text
Scan Status = Succeeded
Compliance  = Non-compliant
```

This does not mean the scan failed.

It means:

```text
Scan completed successfully
        +
Patch compliance issue/missing patches found
```

---

## What does Compliant mean?

Compliant means the node meets the required patch compliance state according to the applicable patch policy/baseline.

Simple way to remember:

```text
Compliant     = Patch compliance is OK
Non-compliant = Patch compliance issue exists
```

---

## How did we perform the Patch Manager Scan lab?

We opened:

```text
AWS Console
→ Systems Manager
→ Patch Manager
→ Patch now
```

We selected:

```text
Patching operation = Scan
```

Then:

```text
Patch only the target instances I specify
```

We selected our test EC2 instance.

For the lab, we selected:

```text
Do not store logs
```

Then we started the scan.

---

## Why did our first Patch Manager scan fail?

Our first EC2 instance was running:

```text
Ubuntu 26.04 LTS
```

The Patch Manager execution failed with:

```text
UnsupportedOperatingSystem
```

The detailed output showed:

```text
This Operating System is not supported by SSM Patch Manager.
```

SSM itself was working because Session Manager and Run Command were already successful.

So the issue was specific to Patch Manager support for that operating system.

---

## What other error did we see during the failed patch scan?

We also saw a package manager lock message:

```text
Could not get lock /var/lib/dpkg/lock-frontend
It is held by process unattended-upgr
```

This indicated that Ubuntu unattended upgrades were using the package manager at that time.

However, the final Patch Manager execution failure in our lab was:

```text
UnsupportedOperatingSystem
Exit Status = 146
```

---

## How did we continue the Patch Manager lab?

We launched a new EC2 instance with:

```text
Ubuntu 24.04 LTS
```

First, we checked SSM Agent:

```bash
snap list amazon-ssm-agent
```

Then we checked that it was running:

```bash
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
```

We also attached the required IAM Role.

Then we ran Patch Manager Scan again.

This time the scan completed successfully.

---

## What did we find after the successful Scan?

After scanning Ubuntu 24.04, Patch Manager showed the node as:

```text
Non-compliant
```

This meant that the scan was successful but patch compliance issues/missing patches were found.

At this stage:

```text
Patches were NOT installed yet.
```

We had only performed the scan.

---

## How did we install patches?

We again opened:

```text
Systems Manager
→ Patch Manager
→ Patch now
```

This time we selected:

```text
Scan and install
```

We selected only our Ubuntu 24.04 test EC2 instance.

For the reboot option, we used:

```text
RebootIfNeeded
```

Then we started the patching operation.

---

## What does RebootIfNeeded mean?

Some operating system patches require a reboot.

With:

```text
RebootIfNeeded
```

Patch Manager can reboot the managed node when required by the patching operation.

In production, we should consider the approved maintenance window, change process, application dependency, and business impact before allowing a reboot.

---

## What was the patch installation result?

Our patching operation completed successfully.

The execution showed:

```text
Status    = Success
Operation = Install
```

---

## How did we validate the server after patching?

After patch installation, we performed another Scan.

This is important because patch installation success alone is not the final validation.

We need to verify the patch status again.

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

This confirmed that the patching and post-patching validation were successful in our lab.

---

## What is the proper patching flow for production?

A general production flow is:

```text
Check/Scan
    |
    v
Review Missing Patches
    |
    v
Change / Approval
    |
    v
Maintenance Window
    |
    v
Install Patches
    |
    v
Reboot If Required
    |
    v
Validate Server/Application
    |
    v
Re-scan
    |
    v
Check Failed/Pending/Missing Patches
```

We should not blindly install patches on production servers just because a node is non-compliant.

---

## How would you explain your production patching experience?

In my environment, we use NinjaRMM for server patching.

We perform patching during the approved maintenance window, monitor the patching status, and after patching we validate the servers and check for failed or pending patches.

---

## What would you say if the interviewer asks for an AWS-native patching option?

AWS Systems Manager Patch Manager is an AWS-native option.

It can be used to scan managed instances for patch compliance, install approved patches, and perform another scan after patching to validate the compliance status.

I have hands-on lab knowledge of AWS Systems Manager Patch Manager.

---

# SSM Parameter Store

## What is SSM Parameter Store?

Parameter Store is a capability of AWS Systems Manager used to centrally store configuration values and sensitive information.

It helps us avoid hard-coding configuration or credentials directly inside application code.

Examples:

- Database host
- Database port
- Environment name
- Database password
- API keys or other sensitive configuration

---

## Why should we not hard-code a DB password?

Suppose the DB password is:

```text
MyDB@123
```

If we write it directly inside application code:

```text
DB_PASSWORD = MyDB@123
```

the password can become exposed through source code, repositories, configuration files, or other copies of the code.

Instead, we can store the password centrally and allow only authorized identities to retrieve it.

---

## What is the difference between String and SecureString?

`String` is used for normal configuration values.

Examples:

```text
DB_PORT = 3306
DB_HOST = db.example.com
ENV = production
```

`SecureString` is used for sensitive values.

Examples:

```text
DB_PASSWORD
API_KEY
Secret Token
```

SecureString uses AWS KMS encryption.

Simple way to remember:

```text
String       = Normal configuration
SecureString = Sensitive configuration + encryption
```

---

## How did we create a DB password in Parameter Store?

We opened:

```text
AWS Console
→ Systems Manager
→ Parameter Store
→ Create parameter
```

We entered the parameter name:

```text
/myapp/db-password
```

We kept the tier as:

```text
Standard
```

We selected:

```text
SecureString
```

For our lab, we used the AWS managed SSM KMS key:

```text
alias/aws/ssm
```

Then we entered a test value:

```text
MyDB@123
```

Finally, we created the parameter.

---

## How does SecureString appear in the AWS Console?

The value is masked.

Example:

```text
********
```

An authorized identity can decrypt/read the value based on the applicable IAM and KMS permissions.

---

## How does an application get the DB password from Parameter Store?

The application does not need to manually open the AWS Console and click on the password.

An application can retrieve the parameter programmatically using an AWS SDK/API.

For learning, we demonstrated the same retrieval using AWS CLI from an EC2 instance.

---

## What command did we use to retrieve the DB password?

We ran:

```bash
aws ssm get-parameter --name "/myapp/db-password" --with-decryption
```

The output returned the parameter information including the decrypted test value.

Example:

```text
Name  = /myapp/db-password
Type  = SecureString
Value = MyDB@123
```

---

## What does the Parameter Store CLI command mean?

Command:

```bash
aws ssm get-parameter --name "/myapp/db-password" --with-decryption
```

Meaning:

```text
aws
→ Use AWS CLI

ssm
→ Use AWS Systems Manager API

get-parameter
→ Retrieve a parameter

--name "/myapp/db-password"
→ Specify which parameter to retrieve

--with-decryption
→ Request the decrypted SecureString value
```

---

## Why was our EC2 able to retrieve the password?

The AWS identity used by the EC2 command had sufficient permission to retrieve the parameter.

If the identity does not have the required permission, AWS returns an access denied error.

In production, we should follow least privilege and allow only the required application/server role to access the required parameter.

---

## If someone has shell access to the application server, can they retrieve the password?

If the person has sufficient shell access to a server and that server's IAM Role is allowed to retrieve/decrypt the parameter, they may also be able to use those permissions to retrieve the value.

Parameter Store does not mean that the password can never be viewed.

Its main benefits are:

- Avoid hard-coding secrets in application code
- Centralized configuration storage
- IAM-controlled access
- KMS encryption for SecureString
- Easier management of configuration values

Server access and IAM permissions must also be properly controlled.

---

## How would you explain Parameter Store in an interview?

SSM Parameter Store is used to centrally store configuration values and sensitive information instead of hard-coding them in application code.

For sensitive values like a database password, we can use SecureString with KMS encryption and control access through IAM permissions.

---

# SSM Complete Lab Flow

## What did we perform in the complete SSM lab?

We first verified that SSM Agent was installed and running on our EC2 instance.

Then we attached the required IAM Role.

After that, we performed the following labs:

```text
1. Session Manager
   |
   └── Remotely accessed EC2 without SSH port 22

2. Run Command
   |
   └── Remotely executed df -h without logging into EC2

3. Patch Manager
   |
   ├── Scanned the server
   ├── Checked compliance
   ├── Installed patches
   └── Re-scanned and validated missing patches = 0

4. Parameter Store
   |
   ├── Created a SecureString DB password
   └── Retrieved it from EC2 using AWS CLI
```

---

# SSM Quick Revision

## What should you remember about SSM for the interview?

```text
SSM Agent
→ Allows the managed node to communicate with Systems Manager

IAM Role
→ Provides required permissions

Session Manager
→ Remote EC2 access without inbound SSH port 22 and PEM key

Run Command
→ Execute commands/scripts remotely on managed instances

Patch Manager
→ Scan, install and verify OS patches

Parameter Store
→ Centrally store configuration and sensitive values
```

---

## How would you explain AWS Systems Manager in an interview?

AWS Systems Manager is used to centrally manage EC2 instances and other managed servers.

We can use Session Manager for remote access without opening inbound SSH port 22, Run Command to remotely execute commands or scripts on managed instances, Patch Manager for operating system patching and compliance, and Parameter Store to centrally store configuration and sensitive values.

I have hands-on lab experience with these Systems Manager features.
