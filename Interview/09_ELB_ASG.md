# ⚖️ ELB & Auto Scaling Group (ASG) – Top 30 Interview Questions

> **Level:** AWS Cloud / Linux Support – L2  
> **Focus:** Concepts + Production Scenarios + Troubleshooting + Cross Questions

---

# Q1. What is Elastic Load Balancer (ELB)?

## Answer

Elastic Load Balancer distributes incoming traffic across multiple targets such as EC2 instances.

It helps improve:

- High Availability
- Fault Tolerance
- Application Availability
- Traffic Distribution

Example:

```text
Users
  ↓
Load Balancer
  ↓
-----------------
↓       ↓       ↓
EC2-1   EC2-2   EC2-3
```

If one EC2 instance becomes unhealthy, the Load Balancer stops sending traffic to that unhealthy target.

---

# Q2. What are the types of Load Balancers in AWS?

## Answer

AWS mainly provides:

### Application Load Balancer (ALB)

Works at Layer 7.

Used for:

- HTTP
- HTTPS
- Host-based routing
- Path-based routing

### Network Load Balancer (NLB)

Works at Layer 4.

Used for:

- TCP
- UDP
- TLS
- High-performance and low-latency applications

### Gateway Load Balancer (GWLB)

Used to deploy and scale third-party virtual network appliances such as firewalls and security appliances.

### Classic Load Balancer (CLB)

Previous-generation Load Balancer.

Supports basic Layer 4 and Layer 7 load balancing, but for new applications we normally use ALB or NLB based on requirement.

---

# Q3. What is the difference between ALB and NLB?

## Answer

| ALB | NLB |
|---|---|
| Works at Layer 7 | Works at Layer 4 |
| HTTP and HTTPS | TCP, UDP and TLS |
| Supports Path-based routing | Does not provide ALB-style URL path routing |
| Supports Host-based routing | Mainly routes based on network connection |
| Good for web applications | Good for high-performance network applications |
| Provides advanced HTTP routing | Designed for very high performance and low latency |

---

# Q4. What is a Target Group?

## Answer

A Target Group is a group of backend targets where the Load Balancer sends traffic.

Targets can include:

- EC2 instances
- IP addresses
- Lambda functions with supported load balancer configurations

For example:

```text
ALB
 ↓
Target Group
 ↓
EC2-1
EC2-2
EC2-3
```

The Load Balancer also uses the Target Group configuration to perform health checks.

---

# Q5. What is a Listener in a Load Balancer?

## Answer

A Listener checks incoming connection requests on a configured protocol and port.

Example:

```text
Listener:
HTTP : 80
```

or

```text
HTTPS : 443
```

Based on Listener rules, the Load Balancer forwards traffic to the required Target Group.

Example:

```text
User
 ↓
ALB : 443
 ↓
Listener Rule
 ↓
Target Group
 ↓
EC2
```

---

# Q6. What is a Health Check in ELB?

## Answer

A Health Check is used by the Load Balancer to verify whether backend targets are healthy and able to serve traffic.

For a web application, we can configure:

```text
Protocol: HTTP
Port: Traffic Port
Path: /health
```

If an instance continuously fails the health check, the Load Balancer marks it unhealthy and stops sending normal traffic to that target.

---

# Q7. What is the difference between Internet-facing and Internal Load Balancer?

## Answer

### Internet-facing Load Balancer

Used for applications that need to receive traffic from the internet.

Example:

```text
Internet
   ↓
Public ALB
   ↓
Application Servers
```

### Internal Load Balancer

Used for internal communication where the Load Balancer should not be directly accessible from the public internet.

Example:

```text
Web Tier
   ↓
Internal ALB
   ↓
Application Tier
```

---

# Q8. What is Path-Based Routing?

## Answer

Path-Based Routing allows an Application Load Balancer to route traffic to different Target Groups based on the URL path.

Example:

```text
example.com/app/*
        ↓
Application Target Group

example.com/images/*
        ↓
Image Target Group
```

It is useful when multiple services are running behind the same ALB.

---

# Q9. What is Host-Based Routing?

## Answer

Host-Based Routing allows an ALB to route traffic based on the hostname.

Example:

```text
app.example.com
      ↓
App Target Group

api.example.com
      ↓
API Target Group
```

This allows multiple applications or services to use the same Application Load Balancer.

---

# Q10. What is Sticky Session?

## Answer

Sticky Session allows the Load Balancer to send requests from the same user to the same target for a configured period.

Normally, requests can be distributed across different healthy instances.

With stickiness:

```text
User-A → EC2-1
User-A → EC2-1
User-A → EC2-1
```

It can be useful for applications that maintain session-related information on a particular backend server.

---

# Q11. What is Cross-Zone Load Balancing?

## Answer

Cross-Zone Load Balancing allows the Load Balancer to distribute traffic across registered targets in enabled Availability Zones.

It helps distribute traffic more evenly across backend targets.

The exact behavior and configuration depend on the Load Balancer type.

---

# Q12. What is SSL/TLS Termination in ALB?

## Answer

For HTTPS applications, the ALB can handle the SSL/TLS connection from the client.

We configure:

- HTTPS Listener on port 443
- SSL/TLS certificate, commonly from AWS Certificate Manager (ACM)

Example:

```text
User
 ↓
HTTPS : 443
 ↓
ALB
 ↓
Target Group
```

The ALB handles the client-side TLS connection and then forwards the request to the backend based on the configured target protocol.

---

# Q13. What is Auto Scaling Group (ASG)?

## Answer

Auto Scaling Group automatically manages the number of EC2 instances based on configured capacity and scaling policies.

It helps maintain:

- Application Availability
- Required Capacity
- Fault Tolerance
- Automatic Scaling

For example:

```text
Minimum Capacity = 2
Desired Capacity = 2
Maximum Capacity = 6
```

If application load increases, ASG can add instances based on the configured scaling policy.

When load decreases, ASG can remove instances.

---

# Q14. What are Minimum, Desired and Maximum Capacity in ASG?

## Answer

### Minimum Capacity

Minimum number of instances ASG should maintain.

### Desired Capacity

Number of instances ASG currently tries to maintain.

### Maximum Capacity

Maximum number of instances ASG is allowed to scale up to.

Example:

```text
Min     = 2
Desired = 3
Max     = 6
```

ASG tries to maintain 3 instances normally, cannot go below 2 through normal scaling, and cannot scale above 6.

---

# Q15. What is a Launch Template?

## Answer

A Launch Template contains the EC2 configuration used by Auto Scaling Group to launch new instances.

It can contain:

- AMI
- Instance Type
- Security Group
- Key Pair
- Storage configuration
- IAM Instance Profile
- User Data

Example:

```text
ASG
 ↓
Launch Template
 ↓
New EC2 Instance
```

Whenever ASG needs a new instance, it launches it based on the configured Launch Template/version.

---

# Q16. What are the common Auto Scaling policies?

## Answer

Common scaling methods include:

### Target Tracking Scaling

ASG automatically adjusts capacity to keep a selected metric near a target value.

Example:

```text
Average CPU Target = 50%
```

### Step Scaling

Scaling action depends on the size of the CloudWatch alarm breach.

Example:

```text
CPU 60–70% → Add 1 Instance
CPU 70–80% → Add 2 Instances
CPU >80%   → Add 3 Instances
```

### Simple Scaling

A CloudWatch alarm triggers a specific scaling action and a cooldown is used before another simple scaling activity.

### Scheduled Scaling

Capacity changes according to a known schedule.

Example:

```text
Every day at 9 AM → Increase Capacity
Every day at 10 PM → Reduce Capacity
```

---

# Q17. What is Target Tracking Scaling?

## Answer

Target Tracking Scaling automatically adjusts ASG capacity to keep a selected metric near a target value.

Example:

```text
Average CPU Utilization Target = 50%
```

If CPU remains above the target, ASG can scale out.

If CPU goes sufficiently below the target and conditions allow, ASG can scale in.

It is similar to maintaining a target value automatically.

---

# Q18. What is the difference between Scale Out and Scale In?

## Answer

### Scale Out

Adding more EC2 instances.

Example:

```text
2 Instances → 4 Instances
```

Usually happens when application load increases.

### Scale In

Removing EC2 instances.

Example:

```text
4 Instances → 2 Instances
```

Usually happens when application load decreases.

**Remember:**

`Scale Out = Add`

`Scale In = Remove`

---

# Q19. How does ASG know when to launch a new EC2 instance?

## Answer

ASG can use scaling policies and CloudWatch metrics/alarms to decide when capacity needs to change.

Example:

```text
CPU High
   ↓
CloudWatch Metric / Alarm
   ↓
Scaling Policy
   ↓
ASG
   ↓
Launch New EC2
```

With Target Tracking, AWS manages the required CloudWatch alarms automatically based on the target tracking policy.

---

# Q20. What happens if an EC2 instance inside ASG becomes unhealthy?

## Answer

ASG monitors instance health.

If an instance is considered unhealthy, ASG can terminate it and launch a replacement instance to maintain the desired capacity.

Example:

```text
Desired Capacity = 3

EC2-1 = Healthy
EC2-2 = Unhealthy
EC2-3 = Healthy

        ↓

ASG replaces EC2-2

        ↓

Again 3 healthy instances
```

If ELB health checks are configured for the ASG, Load Balancer health information can also be used by ASG for health evaluation.

---

# Q21. What is the difference between ELB Health Check and EC2 Health Check?

## Answer

### EC2 Health Check

Checks infrastructure-related instance health, such as EC2 system and instance status.

### ELB Health Check

Checks whether the application/service behind the Load Balancer is responding correctly on the configured protocol, port and health-check path.

An EC2 instance can be running and pass EC2 status checks while the application running on it is unhealthy.

---

# Q22. Target is showing Unhealthy in the Target Group. How will you troubleshoot?

## Answer

First I will check whether the EC2 instance is running and EC2 status checks are passed.

Then I will verify:

- Target Group health-check protocol
- Health-check port
- Health-check path
- Application service status
- Application listening port
- Security Group rules

On Linux, I can check:

```bash
systemctl status <service-name>
ss -tulnp
curl http://localhost:<port>/<health-path>
```

I will also verify that the Load Balancer can reach the target on the required port.

After fixing the issue, I will wait for the health checks to pass and verify that the target becomes healthy.

---

# Q23. Website is accessible directly from EC2 but not through ALB. How will you troubleshoot?

## Answer

First I will check the ALB Listener and Listener rules.

Then I will check whether the EC2 instance is registered in the correct Target Group.

Next I will verify the Target Group health status.

I will also check:

- ALB Security Group
- EC2 Security Group
- Listener port
- Target port
- Health-check configuration
- Application listening port

If HTTPS is being used, I will also verify the certificate and HTTPS Listener configuration.

**Troubleshooting Flow:**

```text
ALB
 ↓
Listener
 ↓
Listener Rule
 ↓
Target Group
 ↓
Target Health
 ↓
Security Groups
 ↓
Application Port
```

---

# Q24. ALB is returning HTTP 503. What will you check?

## Answer

First I will check the Target Group and verify whether healthy targets are available.

If there are no healthy targets, I will check:

- EC2 instance status
- Application service
- Target Group health-check configuration
- Application port
- Security Group rules

I will also check the Load Balancer and application logs if required.

A common reason for ALB 503 is that the Load Balancer has no available target to handle the request.

---

# Q25. ASG is not launching a new instance even though CPU is high. How will you troubleshoot?

## Answer

First I will verify the CloudWatch metric and scaling policy.

Then I will check:

- ASG Minimum, Desired and Maximum capacity
- Whether Maximum capacity is already reached
- Scaling activity history
- CloudWatch alarm status, if applicable
- Launch Template configuration
- EC2 launch errors
- Required service quotas/capacity if the launch itself is failing

For example, if:

```text
Maximum Capacity = 4
Current Capacity = 4
```

ASG cannot scale beyond 4 until the maximum capacity is increased.

---

# Q26. ASG launched a new EC2 instance but application is not working on it. What will you check?

## Answer

First I will verify that the instance was launched using the correct Launch Template and AMI.

Then I will check:

- User Data execution
- Application installation
- Application service status
- Required configuration
- Security Group
- Target Group registration
- Target health

On the Linux server, I can check:

```bash
systemctl status <service-name>
journalctl -u <service-name>
ss -tulnp
```

If bootstrap is performed through User Data, I will also check its logs.

---

# Q27. What happens if Desired Capacity is 2 and one instance is manually terminated?

## Answer

ASG detects that the current capacity is below the desired capacity.

It launches a replacement EC2 instance to bring the capacity back to 2.

Example:

```text
Desired = 2

EC2-1
EC2-2

Manually terminate EC2-2

      ↓

Current Capacity = 1

      ↓

ASG launches new EC2

      ↓

Current Capacity = 2
```

---

# Q28. What happens if Minimum Capacity is set to 0?

## Answer

ASG is allowed to have zero running instances because the minimum capacity does not require any instance to remain running.

Whether it actually scales down to zero depends on the desired capacity and scaling configuration.

For example:

```text
Min     = 0
Desired = 0
Max     = 5
```

The ASG can run with zero instances.

If:

```text
Min     = 0
Desired = 2
Max     = 5
```

ASG will still try to maintain the desired capacity of 2.

---

# Q29. How do you update instances in an ASG after changing the AMI or Launch Template?

## Answer

First we create or update the required Launch Template version with the new AMI or configuration.

Then we update the ASG to use the required Launch Template version.

Existing instances do not automatically become new instances just because the Launch Template was changed.

To replace existing instances in a controlled way, we can use **Instance Refresh**.

Example:

```text
Create New AMI
      ↓
Update Launch Template
      ↓
Update ASG
      ↓
Start Instance Refresh
      ↓
Old Instances Replaced Gradually
```

During the activity, I will monitor instance health and Target Group health to make sure application availability is maintained.

---

# Q30. Application is down even though ASG shows the required number of EC2 instances. How will you troubleshoot?

## Answer

First I will not assume that the application is healthy only because ASG has the required number of instances.

I will check the complete traffic flow.

First I will verify:

- Load Balancer status
- Listener and Listener rules
- Target Group
- Target health

Then I will check the EC2 instances:

- Instance status checks
- CPU and Memory
- Application service status
- Application listening port
- Application logs

I will also verify:

- ALB Security Group
- EC2 Security Group
- Network connectivity
- Health-check configuration

If all instances are unhealthy, I will identify why the application health check is failing.

**Troubleshooting Flow:**

```text
User
 ↓
ALB
 ↓
Listener / Rule
 ↓
Target Group
 ↓
Target Health
 ↓
EC2
 ↓
Application Service
 ↓
Port / Logs
```

The important point is:

**ASG maintains EC2 capacity, but required EC2 count does not always mean the application itself is healthy.**

---

# ⭐ Frequently Asked Cross Questions

### Q1. Can an ALB send traffic to an unhealthy target?

**Answer:**

Normally, the Load Balancer routes normal traffic only to healthy targets when healthy targets are available.

---

### Q2. Can one ALB have multiple Target Groups?

**Answer:**

Yes.

Using Listener rules, one ALB can route traffic to different Target Groups.

Example:

```text
/app/* → TG-App

/api/* → TG-API
```

---

### Q3. Can one Target Group contain multiple EC2 instances?

**Answer:**

Yes.

A Target Group can contain multiple registered targets.

---

### Q4. Can an EC2 instance be healthy at EC2 level but unhealthy in the Target Group?

**Answer:**

Yes.

EC2 status checks may pass, but the application may not be responding on the configured health-check port or path.

---

### Q5. Does changing a Launch Template automatically update existing ASG instances?

**Answer:**

No.

The updated Launch Template is used when new instances are launched.

For controlled replacement of existing instances, we can use Instance Refresh.

---

### Q6. What is the difference between Load Balancer and Auto Scaling?

**Answer:**

Load Balancer distributes incoming traffic across healthy targets.

Auto Scaling manages the number of EC2 instances based on required capacity and scaling configuration.

**Remember:**

```text
ELB = Distribute Traffic

ASG = Manage Number of Instances
```

---

### Q7. If an ASG instance is unhealthy, who replaces it?

**Answer:**

Auto Scaling Group replaces an instance that ASG determines to be unhealthy and launches another instance to maintain the required capacity.

---

### Q8. If CPU utilization increases, does ALB launch a new EC2 instance?

**Answer:**

No.

ALB distributes traffic.

ASG launches or terminates instances based on scaling policies.

---

### Q9. Why do we normally deploy ASG across multiple Availability Zones?

**Answer:**

To improve high availability.

If one Availability Zone has an issue, instances in another Availability Zone can continue serving the application.

---

### Q10. What ELB and ASG activities can you explain in an interview?

**Answer:**

I can explain activities such as:

- Checking Target Group health
- Troubleshooting unhealthy targets
- Verifying Listener and Listener rules
- Checking Load Balancer and EC2 Security Groups
- Checking health-check configuration
- Monitoring ASG capacity
- Checking scaling activities
- Verifying scaling policies
- Checking Launch Template configuration
- Troubleshooting new instance launch issues
- Checking application service and ports on Linux
- Coordinating with application, network and cloud teams during production incidents

---

# 🔥 Final Quick Revision

```text
ELB
= Distributes incoming traffic

ALB
= Layer 7 / HTTP / HTTPS

NLB
= Layer 4 / TCP / UDP / TLS

Listener
= Receives requests on configured protocol/port

Target Group
= Group of backend targets

Health Check
= Checks application/target health

Path-Based Routing
= Route based on URL path

Host-Based Routing
= Route based on hostname

Sticky Session
= Same user can be sent to same target for a configured period

ASG
= Automatically manages EC2 capacity

Minimum
= Minimum capacity ASG should maintain

Desired
= Capacity ASG tries to maintain

Maximum
= Maximum allowed capacity

Launch Template
= Configuration used to launch EC2 instances

Scale Out
= Add instances

Scale In
= Remove instances

Target Tracking
= Maintain metric near target value

Step Scaling
= Scale based on size of alarm breach

Instance Refresh
= Controlled replacement of ASG instances

ALB 503
= Check whether healthy targets are available

Unhealthy Target
= Check Service + Port + SG + Health Check

ASG Not Scaling
= Metric/Alarm + Policy + Max Capacity + Scaling Activity

ASG Capacity Healthy ≠ Application Healthy
```
