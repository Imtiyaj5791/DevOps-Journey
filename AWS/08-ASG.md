# AWS Auto Scaling Group (ASG) - Theory and Complete Hands-on Lab

# Lab Overview

In this lab, we created an Auto Scaling Group and tested the following features:

- Custom AMI
- Launch Template
- Auto Scaling Group
- ALB and Target Group integration
- EC2 and ELB health checks
- Minimum, Desired and Maximum Capacity
- Auto Healing
- Target Tracking Scaling
- Step Scaling
- CloudWatch Alarms
- Scale Out and Scale In
- Instance Warmup
- Launch Template Versioning
- Instance Refresh
- Zero Downtime Deployment
- Scale-in Protection
- Cleanup

---

# Architecture

```text
                         User
                           |
                           v
                      Route 53
                           |
                           v
                          ALB
                           |
                           v
                     Target Group
                           |
                 ---------------------
                 |                   |
                 v                   v
              EC2-1               EC2-2
                 \                   /
                  \                 /
                   Auto Scaling Group
                           |
                           v
                    Launch Template
                           |
                           v
                      Custom AMI
```

---

# What is Auto Scaling Group?

Auto Scaling Group is an AWS service that automatically launches or terminates EC2 instances based on demand.

It also maintains the required number of healthy EC2 instances.

Example:

```text
Desired Capacity = 2
Current Capacity = 1
```

ASG automatically launches one new EC2 instance to restore the desired capacity.

---

# Why Do We Use Auto Scaling Group?

We use ASG for:

- Maintaining application availability
- Replacing unhealthy EC2 instances
- Adding EC2 instances during high traffic
- Removing unnecessary EC2 instances during low traffic
- Reducing cost
- Supporting multiple Availability Zones
- Performing zero downtime instance replacement

---

# Auto Healing vs Auto Scaling

## Auto Healing

Auto Healing replaces an unhealthy or terminated EC2 instance.

```text
Instance Failed
      |
      v
ASG detects capacity mismatch
      |
      v
New EC2 launched
```

## Auto Scaling

Auto Scaling increases or decreases the number of EC2 instances based on traffic or metrics.

```text
CPU High
   |
   v
Add EC2

CPU Low
   |
   v
Remove EC2
```

---

# Custom AMI

AMI is an image of an EC2 instance.

It can contain:

- Operating system
- Apache or Nginx
- Application files
- Installed packages
- Server configuration

We created a custom AMI from the configured Web-1 instance.

Flow:

```text
Configured Web-1
       |
       v
Create AMI
       |
       v
web-1-ami
```

---

# Why Did We Create a Custom AMI?

A normal Ubuntu or Amazon Linux AMI does not contain our application.

Our custom AMI already contained:

- Apache
- Website files
- Application configuration

Therefore, every EC2 launched by ASG had the same application.

---

# Create Custom AMI

Go to:

```text
EC2
|
Instances
|
Select Web-1
|
Actions
|
Image and templates
|
Create image
```

Enter:

```text
Image Name: web-1-ami
Description: Apache Web Server AMI
```

For the live lab, we unchecked:

```text
Reboot instance
```

This avoided temporary downtime during AMI creation.

Wait for:

```text
Pending
   |
   v
Available
```

---

# What is a Launch Template?

Launch Template is a reusable blueprint used to launch EC2 instances.

It contains:

- AMI
- Instance type
- Key pair
- Security group
- Storage
- IAM role
- User data
- Other EC2 settings

ASG uses the Launch Template whenever it needs to launch a new EC2 instance.

---

# Create Launch Template

Go to:

```text
EC2
|
Launch Templates
|
Create Launch Template
```

Enter:

```text
Launch Template Name: web-lt
Description: Launch Template for Auto Scaling
```

Select:

```text
AMI: web-1-ami
Instance Type: t2.micro
Key Pair: Existing Key Pair
Security Group: Web Server Security Group
Storage: Default
User Data: Blank
```

User Data was blank because Apache and the website were already available inside the custom AMI.

We did not select a subnet in the Launch Template because VPC and subnets were selected while creating the Auto Scaling Group.

---

# Create Auto Scaling Group

Go to:

```text
EC2
|
Auto Scaling Groups
|
Create Auto Scaling Group
```

Enter:

```text
ASG Name: web-asg
Launch Template: web-lt
Version: Latest
```

---

# Configure Networking

Select:

```text
VPC: Default VPC
```

We selected multiple Availability Zones:

```text
ap-south-1a
ap-south-1b
ap-south-1c
```

Using multiple Availability Zones improves availability.

If one Availability Zone has a problem, ASG can launch instances in another selected Availability Zone.

---

# Attach ASG to Load Balancer

Select:

```text
Attach to an existing load balancer
```

Then select:

```text
Choose from your load balancer target groups
Target Group: web-tg
```

Enable:

```text
Elastic Load Balancing health checks
```

Final flow:

```text
ASG
 |
 v
web-tg
 |
 v
ALB
```

---

# EC2 Health Check vs ELB Health Check

## EC2 Health Check

It checks whether the EC2 instance is running properly.

It can detect:

- Hardware failure
- Operating system failure
- EC2 status check failure

## ELB Health Check

It checks whether the application is responding properly.

Example:

```text
EC2 Running = Yes
Apache Running = No
```

EC2 health check may show the instance as healthy, but the ELB health check will fail because the website is not responding.

For production applications, we normally enable both EC2 and ELB health checks.

---

# Minimum, Desired and Maximum Capacity

We configured:

```text
Minimum Capacity = 2
Desired Capacity = 2
Maximum Capacity = 4
```

## Desired Capacity

Desired Capacity is the number of instances ASG tries to maintain.

Example:

```text
Desired = 2
Current = 1
```

ASG launches one new EC2 instance.

## Minimum Capacity

Minimum Capacity is the lowest number of instances ASG is allowed to maintain during scale-in.

Example:

```text
Minimum = 2
```

ASG will not reduce the group below two instances.

## Maximum Capacity

Maximum Capacity is the highest number of instances ASG is allowed to launch.

Example:

```text
Maximum = 4
```

Even if CPU is 100%, ASG will not launch a fifth instance.

---

# Important Minimum Capacity Scenario

Configuration:

```text
Minimum = 0
Desired = 2
Maximum = 4
```

Policy:

```text
CPU < 5%
Remove 1 instance
```

First scale-in:

```text
2 EC2
  |
  v
1 EC2
```

If the policy is triggered again:

```text
1 EC2
  |
  v
0 EC2
```

When zero healthy EC2 instances remain behind the ALB, the website becomes unavailable and the ALB may return:

```text
503 Service Unavailable
```

For a production website, we normally keep the minimum capacity at least one.

For high availability, we normally keep at least two instances in different Availability Zones.

---

# Auto Healing Hands-on Test

After creating the ASG, two new EC2 instances were launched because:

```text
Desired Capacity = 2
```

We verified:

```text
Lifecycle State: InService
Health Status: Healthy
```

We manually terminated one ASG instance.

Expected flow:

```text
Desired = 2
Current = 2
      |
One EC2 terminated
      |
      v
Current = 1
      |
      v
ASG uses Launch Template
      |
      v
New EC2 launched
      |
      v
Target Group registration
      |
      v
Health Check passed
      |
      v
Current = 2
```

The website remained available because the second healthy instance continued serving traffic.

This feature is called:

```text
Auto Healing
```

---

# Troubleshooting Issue Faced During Termination

While terminating an EC2 instance, AWS Console displayed:

```text
Failed to terminate instance: Failed to request credentials
```

This was an AWS Console session issue.

After refreshing the page, termination worked successfully.

---

# Target Tracking Scaling

Target Tracking automatically tries to maintain a target metric.

Example:

```text
Target CPU Utilization = 30%
```

We do not manually define:

```text
CPU > 80% = Add 1
CPU < 20% = Remove 1
```

Instead, we only define the target value.

AWS automatically:

- Creates CloudWatch High and Low alarms
- Monitors average CPU
- Decides how many instances to add
- Decides when to remove extra instances

---

# Target Tracking Flow

```text
Target CPU = 30%
       |
Actual CPU higher than target
       |
       v
CloudWatch AlarmHigh
       |
       v
ASG Scale Out
       |
       v
New EC2 instances launched
```

When CPU becomes lower:

```text
Actual CPU lower than target
       |
       v
CloudWatch AlarmLow
       |
       v
ASG Scale In
       |
       v
Extra EC2 instances terminated
```

---

# Create Target Tracking Policy

Go to:

```text
Auto Scaling Groups
|
web-asg
|
Automatic Scaling
|
Create Dynamic Scaling Policy
```

Select:

```text
Policy Type: Target Tracking Scaling
Metric Type: Average CPU Utilization
Target Value: 30
Instance Warmup: 300 seconds
```

After creating the policy, AWS automatically created two CloudWatch alarms:

```text
TargetTracking-web-asg-AlarmHigh
TargetTracking-web-asg-AlarmLow
```

---

# Target Tracking Practical Test

Initially:

```text
Running EC2 = 2
Target CPU = 30%
```

We generated CPU load using:

```bash
stress --cpu 1 --timeout 600
```

To run it in the background:

```bash
stress --cpu 1 --timeout 600 &
```

To check CPU:

```bash
top
```

To stop the stress process:

```bash
pkill stress
```

To verify:

```bash
ps -ef | grep stress
```

CPU reached approximately:

```text
99%
```

Target Tracking detected that the average CPU was above the target and launched two additional EC2 instances.

Result:

```text
Before = 2 EC2
After  = 4 EC2
```

Target Tracking added two instances because AWS calculated that more capacity was required to bring average CPU closer to the configured target.

---

# Why Did Stress on One EC2 Not Trigger Scaling Properly?

Initially, stress was run on only one ASG instance.

Example:

```text
EC2-1 CPU = 100%
EC2-2 CPU = 0%
```

ASG uses average CPU:

```text
Average CPU = (100 + 0) / 2
Average CPU = 50%
```

When the Target Tracking value was also close to 50%, scaling did not happen as expected.

For the Step Scaling test, we ran stress on both ASG instances so that average CPU became approximately 99%.

---

# CloudWatch AlarmHigh and AlarmLow

## AlarmHigh

AlarmHigh enters the `ALARM` state when the monitored metric is above the target.

Result:

```text
AlarmHigh = ALARM
        |
        v
Scale Out
```

## AlarmLow

AlarmLow enters the `ALARM` state when the monitored metric is sufficiently below the target.

Result:

```text
AlarmLow = ALARM
       |
       v
Scale In
```

Target Tracking creates these alarms automatically.

---

# Step Scaling

Step Scaling allows us to define different scaling actions for different metric ranges.

Example:

```text
CPU 80% to 90%  = Add 1 EC2
CPU above 90%   = Add 1 EC2
```

Unlike Target Tracking, Step Scaling requires us to manually create:

- CloudWatch High CPU Alarm
- CloudWatch Low CPU Alarm
- Scale-Out Policy
- Scale-In Policy
- Scaling steps and actions

---

# Target Tracking vs Step Scaling

## Target Tracking

```text
Maintain CPU at 30%
```

AWS automatically:

- Creates alarms
- Calculates scaling capacity
- Performs scale out
- Performs scale in

## Step Scaling

```text
CPU 80% to 90% = Add 1
CPU above 90%  = Add 1
CPU below 20%  = Remove 1
```

We manually define:

- Thresholds
- Metric ranges
- Number of instances to add or remove
- High and Low CloudWatch alarms

---

# Create High CPU CloudWatch Alarm

Go to:

```text
CloudWatch
|
Alarms
|
Create Alarm
|
Select Metric
|
EC2
|
By Auto Scaling Group
|
web-asg
|
CPUUtilization
```

Configure:

```text
Statistic: Average
Period: 1 minute
Threshold Type: Static
Condition: Greater than or equal to 80
Alarm Name: web-asg-high-cpu
```

SNS notification was skipped because the alarm was created only for the scaling lab.

---

# Create Scale-Out Step Scaling Policy

Go to:

```text
EC2
|
Auto Scaling Groups
|
web-asg
|
Automatic Scaling
|
Create Dynamic Scaling Policy
```

Select:

```text
Policy Type: Step Scaling
Policy Name: ScaleOut-Add1
CloudWatch Alarm: web-asg-high-cpu
Adjustment Type: Change in capacity
```

Steps:

```text
80 <= CPU < 90
Add 1 Capacity Unit

90 <= CPU < Infinity
Add 1 Capacity Unit
```

This means:

```text
Current EC2 = 2
CPU = 85%
Result = 3 EC2
```

If CPU remains above 90% after the next evaluation:

```text
Current EC2 = 3
CPU > 90%
Result = 4 EC2
```

The action applies to the current capacity.

---

# Create Low CPU CloudWatch Alarm

Create another CloudWatch Alarm:

```text
Metric: CPUUtilization
Statistic: Average
Period: 1 minute
Condition: Less than 20
Alarm Name: web-asg-low-cpu
```

---

# Create Scale-In Step Scaling Policy

Go to:

```text
Auto Scaling Groups
|
web-asg
|
Automatic Scaling
|
Create Dynamic Scaling Policy
```

Configure:

```text
Policy Type: Step Scaling
Policy Name: ScaleIn-Remove1
CloudWatch Alarm: web-asg-low-cpu
Adjustment Type: Change in capacity
Action: Remove 1 Capacity Unit
```

Expected flow:

```text
4 EC2
  |
CPU Low
  |
  v
3 EC2
  |
CPU Still Low
  |
  v
2 EC2
```

It will not go below:

```text
Minimum Capacity = 2
```

---

# Step Scaling Practical Test

We ran stress on both ASG instances:

```bash
stress --cpu 1 --timeout 600 &
```

CPU reached approximately:

```text
99%
```

CloudWatch High CPU Alarm changed to:

```text
ALARM
```

ASG Activity showed:

```text
Launching a new EC2 instance
```

The group scaled:

```text
2 EC2
  |
  v
3 EC2
  |
CPU remained high
  |
  v
4 EC2
```

Because:

```text
Maximum Capacity = 4
```

ASG stopped at four instances.

After stopping stress:

```bash
pkill stress
```

CPU became low.

The Low CPU Alarm triggered the scale-in policy.

ASG gradually reduced capacity:

```text
4 EC2
  |
  v
3 EC2
  |
  v
2 EC2
```

---

# Simple Scaling

Simple Scaling uses one alarm and one scaling action.

Example:

```text
CPU > 80%
Add 1 EC2
```

After the action, ASG waits for the cooldown period before allowing another scaling action.

Step Scaling is more flexible because it supports multiple metric ranges and multiple actions inside the same policy.

---

# Instance Warmup

Instance Warmup is the time given to a newly launched instance before its metrics are used for further scaling decisions.

Example:

```text
New EC2 launched
       |
       v
Warmup period
       |
       v
ASG waits before another scaling decision
```

In our lab:

```text
Instance Warmup = 300 seconds
```

During Step Scaling, ASG Activity displayed:

```text
Waiting for instance warm up
```

After the warmup completed, ASG evaluated CPU again and launched the fourth EC2 because CPU was still high.

Simple interview answer:

> Instance Warmup gives the newly launched EC2 some time before Auto Scaling uses its metrics for another scaling decision.

---

# Health Check Grace Period

Health Check Grace Period is the time ASG waits before evaluating health checks for a newly launched EC2 instance.

It prevents ASG from marking the instance unhealthy while:

- Operating system is booting
- Application is starting
- Apache or Nginx is starting
- Health-check endpoint is becoming available

Simple interview answer:

> Health Check Grace Period delays health-check evaluation for a newly launched instance.

---

# Cooldown Period

Cooldown Period is the waiting time after a scaling activity before another Simple Scaling action is allowed.

Simple interview answer:

> Cooldown Period prevents another scaling action immediately after the previous scaling activity.

---

# Warmup vs Grace Period vs Cooldown

| Feature | Main Purpose |
|---|---|
| Instance Warmup | Wait before using new instance metrics for another scaling decision |
| Health Check Grace Period | Wait before evaluating the new instance health |
| Cooldown Period | Wait after a Simple Scaling activity before another scaling action |

Memory:

```text
Warmup     = Scaling metrics
Grace      = Health checks
Cooldown   = Next scaling action
```

---

# Launch Template Versioning

Launch Templates support multiple versions.

We initially had:

```text
Launch Template Version 1
AMI: web-1-ami
```

We updated the website content to:

```text
Welcome to Web-1 V2
```

Then we created a new AMI:

```text
web-ami-v2
```

After that, we created:

```text
Launch Template Version 2
AMI: web-ami-v2
```

We did not create a separate Launch Template.

Versioning helps us:

- Keep configuration history
- Roll back to an older version
- Update AMI
- Update instance type
- Update security group
- Update user data

---

# Important Launch Template Question

Updating the ASG to Launch Template Version 2 does not automatically replace existing EC2 instances.

Existing instances continue using the old configuration.

New instances launched in the future will use Version 2.

To replace existing instances, we must start an Instance Refresh.

---

# Instance Refresh

Instance Refresh gradually replaces old ASG instances with new instances using the updated Launch Template version.

Flow:

```text
Old Instances using AMI V1
          |
Update ASG to Launch Template V2
          |
Start Instance Refresh
          |
Launch New V2 Instance
          |
Wait for Healthy
          |
Terminate Old V1 Instance
          |
Repeat
          |
All Instances running V2
```

---

# Zero Downtime Deployment Practical

Before update:

```text
Website: Welcome to Web-1
```

We changed the content to:

```text
Website: Welcome to Web-1 V2
```

Then:

1. Created `web-ami-v2`
2. Created Launch Template Version 2
3. Updated the ASG to Version 2
4. Started Instance Refresh
5. Selected launch-before-terminate behaviour

During refresh, browser responses alternated:

```text
Old Website
New Website
Old Website
New Website
```

This happened because both old and new instances were temporarily registered behind the ALB.

The ALB distributed requests between them.

After refresh completed, every request displayed:

```text
Welcome to Web-1 V2
```

At no point did the website return:

```text
503 Service Unavailable
Site cannot be reached
Connection timed out
```

This proved zero downtime deployment.

---

# Minimum and Maximum Healthy Percentage

These percentages are based on the ASG Desired Capacity.

## Minimum Healthy Percentage

It defines the minimum percentage of desired capacity that must remain healthy during Instance Refresh.

Example:

```text
Desired Capacity = 10
Minimum Healthy = 100%
```

AWS tries to maintain ten healthy instances during the refresh.

## Maximum Healthy Percentage

It defines how much temporary additional capacity can be used during Instance Refresh.

Example:

```text
Desired Capacity = 10
Maximum Healthy = 120%
```

ASG may temporarily use up to twelve instances during the refresh, depending on the refresh configuration and replacement process.

A higher value can make the refresh faster but may increase temporary EC2 cost.

---

# Launch Before Terminate

In this method, ASG launches a new instance first.

After the new instance becomes healthy, ASG terminates an old instance.

Flow:

```text
Old-1
Old-2
   |
Launch New-1
   |
New-1 becomes healthy
   |
Terminate Old-1
   |
Launch New-2
   |
New-2 becomes healthy
   |
Terminate Old-2
```

This method helps maintain availability during Instance Refresh.

---

# Scale-in Protection

Scale-in Protection prevents a selected ASG instance from being terminated during a normal scale-in event.

Practical:

```text
EC2-A = Protected
EC2-B = Not Protected
Desired = 2
```

We changed:

```text
Desired = 1
```

ASG needed to terminate one instance.

Result:

```text
Protected EC2-A = Running
Non-protected EC2-B = Terminated
```

This proved that scale-in protection was working.

---

# Enable Scale-in Protection

Go to:

```text
EC2
|
Auto Scaling Groups
|
web-asg
|
Instance Management
```

Select one instance.

Then:

```text
Actions
|
Set Scale-in Protection
|
Enable
```

---

# Important Scale-in Protection Limitation

Scale-in Protection mainly protects an instance from normal Auto Scaling scale-in events.

It may not protect the instance from:

- Manual EC2 termination
- Health-check replacement
- Spot interruption
- Certain Instance Refresh actions
- ASG deletion

---

# Lifecycle Hook - Interview Overview

Lifecycle Hook pauses an EC2 instance during launch or termination.

## Launch Hook

```text
EC2 Launch
   |
Wait State
   |
Install Application
Configure Server
Install Agent
   |
Complete Lifecycle Action
   |
InService
```

## Termination Hook

```text
EC2 Termination
   |
Wait State
   |
Upload Logs
Take Backup
Send Notification
   |
Complete Lifecycle Action
   |
Terminate
```

Simple interview answer:

> Lifecycle Hook pauses an instance during launch or termination so that we can perform custom activities before the instance continues its lifecycle.

Lifecycle Hook was covered only at interview level and not implemented in this lab.

---

# Production Monitoring Flow

A common production alert flow is:

```text
AWS Resource
     |
CloudWatch Metric
     |
CloudWatch Alarm
     |
SNS
     |
Opsgenie
     |
Incident
     |
On-call Engineer
```

Example:

```text
CPU > 80%
    |
CloudWatch Alarm
    |
SNS
    |
Opsgenie
    |
Engineer receives alert
```

SNS and Opsgenie integration will be covered with the CloudWatch module.

---

# Common ASG Activity Messages

## Launching Instance

```text
Launching a new EC2 instance
```

ASG is increasing capacity or replacing an unhealthy instance.

## Waiting for Instance Warmup

```text
Waiting for instance warm up
```

ASG is waiting before making another scaling decision.

## Terminating Instance

```text
Terminating EC2 instance
```

ASG is reducing capacity or replacing an old instance.

## Successful Launch

```text
Successfully launched instance
```

The instance was created successfully.

## Insufficient Capacity

```text
Insufficient t2.micro capacity in the requested Availability Zone
```

AWS did not have enough capacity for that instance type in the selected Availability Zone.

Possible solutions:

- Use another Availability Zone
- Use another instance type
- Create a new Launch Template version
- Use mixed instance types

---

# Production Scenarios

## One EC2 Instance Failed

ASG detects that current capacity is lower than desired capacity.

It automatically launches a replacement instance using the Launch Template.

---

## CPU Suddenly Increased

CloudWatch Alarm or Target Tracking detects high CPU.

ASG launches new EC2 instances until:

- The target metric is stable
- Or maximum capacity is reached

---

## CPU Remains High at Maximum Capacity

Example:

```text
Maximum Capacity = 4
Current Capacity = 4
CPU = 100%
```

ASG will not launch the fifth instance because it cannot go above the configured maximum capacity.

The team should:

- Review maximum capacity
- Check application bottleneck
- Check database performance
- Check traffic pattern
- Check whether instance type is sufficient

---

## Website Down but EC2 is Running

Possible reason:

- Apache or Nginx stopped
- Application process stopped
- Wrong health-check path
- Security group issue
- Application returning non-200 response

ELB Health Check can mark the instance unhealthy, and ASG can replace it if ELB health checks are enabled.

---

## ASG Launch Failed

Check:

```text
ASG
|
Activity History
```

Possible reasons:

- Insufficient instance capacity
- Invalid AMI
- Deleted AMI
- Wrong Launch Template version
- Invalid security group
- Key pair issue
- Service quota exceeded
- Subnet has no available IP addresses

---

## Updated Launch Template but Existing EC2 Did Not Change

This is expected.

Updating a Launch Template only affects future instances.

To replace existing instances, start an Instance Refresh.

---

## Zero Downtime Application Update

Process:

```text
Update application on source EC2
       |
Create new AMI
       |
Create Launch Template Version 2
       |
Update ASG to Version 2
       |
Start Instance Refresh
       |
Launch new before terminating old
       |
Verify Target Group health
       |
Complete refresh
```

---

# Interview Questions and Answers

## What is Auto Scaling Group?

> Auto Scaling Group automatically launches or terminates EC2 instances based on demand. It also maintains the desired number of healthy instances.

---

## What is a Launch Template?

> Launch Template is a reusable EC2 configuration containing the AMI, instance type, security group, key pair, storage and other settings. ASG uses it to launch new instances.

---

## Why Did You Create a Custom AMI?

> I created a custom AMI because it already contained Apache, application files and the required server configuration. New ASG instances were ready with the same application.

---

## What is Desired Capacity?

> Desired Capacity is the number of EC2 instances that Auto Scaling tries to maintain.

---

## What is Minimum Capacity?

> Minimum Capacity is the lowest number of EC2 instances that the ASG can maintain during scale-in.

---

## What is Maximum Capacity?

> Maximum Capacity is the highest number of EC2 instances that the ASG is allowed to launch.

---

## What Happens if Desired is 2 and One Instance is Terminated?

> Auto Scaling detects that the current capacity is lower than the desired capacity. It automatically launches a replacement instance using the Launch Template.

---

## What is Auto Healing?

> Auto Healing means that ASG automatically replaces a failed, unhealthy or terminated EC2 instance and restores the desired capacity.

---

## What is Target Tracking Scaling?

> In Target Tracking, we define a target metric such as 50% CPU utilization. AWS automatically creates the CloudWatch alarms and increases or decreases instances to maintain that target.

---

## What is Step Scaling?

> Step Scaling allows us to define different scaling actions for different metric ranges. For example, CPU between 80% and 90% can add one instance, while CPU above 90% can add two instances.

---

## Difference Between Target Tracking and Step Scaling?

> In Target Tracking, we define only the target value and AWS manages the alarms and scaling decisions. In Step Scaling, we manually create CloudWatch alarms and define exact scaling actions for different ranges.

---

## Which Scaling Policy is Better?

> Target Tracking is simpler and suitable for most workloads. Step Scaling is useful when the business requires exact control over scaling actions for different metric ranges.

---

## What is Instance Warmup?

> Instance Warmup gives a newly launched EC2 instance some time before Auto Scaling uses its metrics for another scaling decision.

---

## What is Health Check Grace Period?

> Health Check Grace Period delays health-check evaluation for a newly launched instance so that the operating system and application have time to start.

---

## What is Cooldown Period?

> Cooldown Period is the waiting time after a Simple Scaling activity before another scaling activity is allowed.

---

## What is Instance Refresh?

> Instance Refresh gradually replaces existing EC2 instances with new instances using the updated Launch Template version.

---

## How Did You Perform Zero Downtime Deployment?

> I updated the application, created a new AMI, created Launch Template Version 2 and started Instance Refresh. ASG launched new instances, waited until they became healthy and then terminated the old instances. The website remained available during the complete process.

---

## Why Did Old and New Pages Appear During Instance Refresh?

> During Instance Refresh, old and new instances were temporarily registered in the same Target Group. The ALB distributed requests between them until all old instances were replaced.

---

## Does Updating the Launch Template Automatically Update Existing Instances?

> No. Existing instances continue using the old configuration. We need to start an Instance Refresh to replace them.

---

## What is Scale-in Protection?

> Scale-in Protection prevents a specific ASG instance from being terminated during a normal scale-in event.

---

## What is Lifecycle Hook?

> Lifecycle Hook pauses an EC2 instance during launch or termination so that we can perform custom tasks such as installing an application, taking a backup or uploading logs.

---

## Why Do We Enable ELB Health Checks in ASG?

> EC2 health checks only verify the instance status. ELB health checks verify whether the application is responding. If the application is unhealthy, ASG can replace the instance.

---

## Why is Scale-In Slower Than Scale-Out?

> Scale-out is faster because the application needs capacity immediately. Scale-in is conservative to avoid terminating instances due to temporary traffic changes and affecting active users.

---

## Why Should Minimum Capacity Not Be Zero for a Production Website?

> If repeated scale-in actions reduce the group to zero instances, the Load Balancer will have no healthy backend and the website will become unavailable. Therefore, production websites normally keep minimum capacity at least one, and often two for high availability.

---

## What Will You Check if ASG Cannot Launch an Instance?

> I will check the Auto Scaling Activity History, Launch Template, AMI, instance type capacity, subnet IP availability, security group, service quotas and the selected Availability Zones.

---

# Commands Used in the Lab

## Install Stress on Ubuntu

```bash
sudo apt update
sudo apt install stress -y
```

## Run Stress for 10 Minutes

```bash
stress --cpu 1 --timeout 600
```

## Run Stress in Background

```bash
stress --cpu 1 --timeout 600 &
```

## Check CPU

```bash
top
```

## Stop Stress

```bash
pkill stress
```

## Verify Stress Process

```bash
ps -ef | grep stress
```

---

# Cleanup Order

To avoid unnecessary AWS billing, we deleted resources in the following order:

```text
1. Auto Scaling Group
2. Verify ASG EC2 instances terminated
3. Application Load Balancer
4. Target Groups
5. Launch Template
6. Deregister Custom AMIs
7. Delete AMI Snapshots
8. Delete CloudWatch Alarms
9. Delete Manual EC2 Instances
10. Delete Unused EBS Volumes
11. Delete Route 53 Alias Records
12. Delete Route 53 Hosted Zone
13. Delete ACM Certificate
14. Delete Unused Security Groups
```

Important:

```text
AMI deregistration does not automatically delete its EBS snapshot.
```

The snapshot must be deleted separately to stop snapshot storage charges.

---

# Final Lab Result

We successfully verified:

```text
Custom AMI                         ✅
Launch Template                    ✅
ASG Creation                       ✅
ALB Integration                    ✅
EC2 and ELB Health Checks          ✅
Auto Healing                       ✅
Target Tracking                    ✅
Automatic CloudWatch Alarms        ✅
Step Scaling                       ✅
Manual CloudWatch Alarms           ✅
Scale Out: 2 → 3 → 4              ✅
Scale In: 4 → 3 → 2               ✅
Instance Warmup                    ✅
Launch Template Version 2          ✅
Instance Refresh                   ✅
Zero Downtime V1 → V2 Update       ✅
Scale-in Protection                ✅
Complete Cleanup                   ✅
```

# End of Auto Scaling Group Module
