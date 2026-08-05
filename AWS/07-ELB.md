

## What is Elastic Load Balancer (ELB)?

Elastic Load Balancer (ELB) is an AWS service that automatically distributes incoming traffic across multiple EC2 instances. It improves High Availability, Fault Tolerance, and Scalability.

---

## Why do we use ELB?

- To distribute traffic across multiple EC2 instances.
- To avoid a single point of failure.
- To improve application availability.
- To perform health checks.
- To work with Auto Scaling Group.

---

## Types of Load Balancer

### 1. Application Load Balancer (ALB)

- Layer 7 Load Balancer.
- Supports HTTP and HTTPS.
- Supports Path Based Routing.
- Supports Host Based Routing.
- Supports WebSocket and HTTP/2.

Example:
```
Client
   │
HTTP/HTTPS
   │
ALB
   │
EC2 Instances
```

---

### 2. Network Load Balancer (NLB)

- Layer 4 Load Balancer.
- Supports TCP, UDP and TLS.
- High performance.
- Low latency.
- Static IP.

---

### 3. Gateway Load Balancer (GWLB)

Used with Network Virtual Appliances like Firewall and IDS/IPS.

---

# Internet Facing vs Internal Load Balancer

### Internet Facing

Accessible from the Internet.

Example:

```
Internet
   │
Internet Facing ALB
   │
EC2
```

---

### Internal Load Balancer

Accessible only inside the VPC.

Example:

```
Application Server
        │
Internal ALB
        │
Database/Application
```

---

# Listener

Listener is the entry point of the Load Balancer.

It listens on a specific Protocol and Port.

Example

```
HTTP : 80
HTTPS : 443
```

Interview Answer:

**Listener receives the client request on a specific protocol and port, then forwards it to the Target Group according to the configured rules.**

---

# Target Group

A Target Group is a collection of backend targets (EC2 instances).

ALB forwards the request to the Target Group.

Example

```
ALB
 │
 ▼
Target Group
 │
 ├── Web-1
 └── Web-2
```

---

# Health Check

Health Check continuously verifies whether the application is working properly.

If the health check fails continuously, ALB marks the instance as Unhealthy and stops sending traffic.

Once the application responds successfully again, ALB marks it Healthy and starts sending traffic again.

---

## Health Check Components

- Protocol
- Port
- Path
- Healthy Threshold
- Unhealthy Threshold
- Timeout
- Interval

---

## Health Check Path

Health Check Path tells ALB which URL should be checked.

Example

```
/
```

or

```
/health
```

If the configured path returns HTTP 200, ALB marks the target Healthy.

---

# AWS ELB Day 1 – Application Load Balancer Hands-on

## Lab Architecture

```text
                    Internet
                        |
                        v
              Application Load Balancer
                        |
                        v
                  Target Groups
                  /           \
                 v             v
              Web-1           Web-2
```

---

# Part 1 – Create Two EC2 Instances

## Step 1 – Launch Web-1

Go to:

```text
AWS Console → EC2 → Instances → Launch instance
```

Use:

```text
Name: Web-1
AMI: Ubuntu
Instance type: t2.micro
Key pair: Existing key pair
VPC: Default VPC
Public IP: Enable
Storage: 8 GB
```

Create a Security Group:

```text
Name: Web-SG
```

Inbound rules:

```text
SSH   Port 22   Source: My IP
HTTP  Port 80   Source: Anywhere
```

Launch the instance.

---

## Step 2 – Launch Web-2

Launch another EC2 instance with the same configuration.

Only change:

```text
Name: Web-2
```

Use the same:

```text
Web-SG
```

---

# Part 2 – Install Apache

## Step 1 – Configure Web-1

Connect to Web-1 and run:

```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
```

Create the Web-1 page:

```bash
echo "<h1>Welcome to Web-1</h1>" | sudo tee /var/www/html/index.html
```

Verify Apache:

```bash
sudo systemctl status apache2
```

Open the EC2 public IP:

```text
http://WEB-1-PUBLIC-IP
```

Expected output:

```text
Welcome to Web-1
```

---

## Step 2 – Configure Web-2

Connect to Web-2 and run:

```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
```

Create the Web-2 page:

```bash
echo "<h1>Welcome to Web-2</h1>" | sudo tee /var/www/html/index.html
```

Open the EC2 public IP:

```text
http://WEB-2-PUBLIC-IP
```

Expected output:

```text
Welcome to Web-2
```

---

# Part 3 – Create Target Group

Go to:

```text
EC2 → Target Groups → Create target group
```

## Step 1 – Basic Configuration

Select:

```text
Target type: Instances
Target group name: web-tg
Protocol: HTTP
Port: 80
VPC: Default VPC
```

Reason:

```text
Apache is running on HTTP port 80.
```

---

## Step 2 – Health Check Configuration

Use:

```text
Health check protocol: HTTP
Health check path: /
```

Reason:

```text
Apache home page is available at /
```

Click:

```text
Next
```

---

## Step 3 – Register Targets

Select:

```text
Web-1
Web-2
```

Click:

```text
Include as pending below
```

Then click:

```text
Create target group
```

---

# Part 4 – Create Application Load Balancer

Go to:

```text
EC2 → Load Balancers → Create Load Balancer
```

Select:

```text
Application Load Balancer
```

---

## Step 1 – Basic Configuration

Use:

```text
Name: web-alb
Scheme: Internet-facing
IP address type: IPv4
```

Reason:

```text
Users will access the application from the internet.
```

---

## Step 2 – Network Mapping

Select:

```text
VPC: Default VPC
```

Select at least two Availability Zones and their public subnets.

Example:

```text
ap-south-1a
ap-south-1b
```

Reason:

```text
ALB requires at least two Availability Zones for high availability.
```

---

## Step 3 – Create ALB Security Group

Create a new Security Group:

```text
Name: ALB-SG
```

Inbound rule:

```text
HTTP
Port: 80
Source: 0.0.0.0/0
```

Outbound:

```text
All traffic
```

Reason:

```text
Internet users need to access ALB on HTTP port 80.
```

---

## Step 4 – Configure Listener

Use:

```text
Protocol: HTTP
Port: 80
```

Reason:

```text
Users will open the ALB DNS using HTTP.
```

---

## Step 5 – Attach Target Group

In default action select:

```text
Forward to target group
Target group: web-tg
```

Create the Load Balancer.

Wait until the state becomes:

```text
Active
```

---

# Part 5 – Verify Basic ALB

Copy the ALB DNS name.

Open:

```text
http://ALB-DNS
```

Refresh multiple times.

Expected output:

```text
Welcome to Web-1
```

and

```text
Welcome to Web-2
```

This confirms that ALB is distributing traffic between both EC2 instances.

---

# Part 6 – Secure EC2 Security Group

Initially Web-SG allowed:

```text
HTTP 80 → Anywhere
```

Now remove that rule.

Add:

```text
Type: HTTP
Port: 80
Source: ALB-SG
```

Keep SSH rule:

```text
SSH 22 → My IP
```

Final flow:

```text
Internet
    |
    v
ALB-SG
    |
    v
Web-SG
    |
    v
EC2
```

Now:

```text
ALB DNS → Website opens
EC2 Public IP → Website does not open directly
```

---

# Part 7 – Health Check Failure Lab

## Step 1 – Stop Apache on Web-1

Run on Web-1:

```bash
sudo systemctl stop apache2
```

Wait for the health check.

Go to:

```text
EC2 → Target Groups → web-tg → Targets
```

Expected:

```text
Web-1 → Unhealthy
Web-2 → Healthy
```

Open ALB DNS and refresh.

Expected:

```text
Only Web-2 response will appear
```

---

## Step 2 – Start Apache Again

Run:

```bash
sudo systemctl start apache2
```

After successful health checks:

```text
Web-1 → Healthy
Web-2 → Healthy
```

---

# Part 8 – Wrong Health Check Path Lab

Go to:

```text
EC2 → Target Groups → web-tg → Health checks → Edit
```

Change:

```text
/
```

to:

```text
/wrong
```

Save changes.

Expected:

```text
Web-1 → Unhealthy
Web-2 → Unhealthy
```

Reason:

```text
/wrong does not exist on either server.
```

Important observation:

```text
Application is running
Health check configuration is wrong
```

When all targets are unhealthy, ALB may use fail-open behavior and still forward requests to registered targets.

Restore the path:

```text
/
```

Wait until both targets become healthy again.

---

# Part 9 – Path-Based Routing Lab

## Goal

```text
/ app1  → Web-1
/ app2  → Web-2
```

Final testing URLs:

```text
http://ALB-DNS/app1/
http://ALB-DNS/app2/
```

---

## Step 1 – Create Application Path on Web-1

Run on Web-1:

```bash
sudo mkdir -p /var/www/html/app1
echo "<h1>Welcome to APP-1</h1>" | sudo tee /var/www/html/app1/index.html
```

Verify locally:

```bash
curl http://localhost/app1/
```

Expected:

```html
<h1>Welcome to APP-1</h1>
```

---

## Step 2 – Create Application Path on Web-2

Run on Web-2:

```bash
sudo mkdir -p /var/www/html/app2
echo "<h1>Welcome to APP-2</h1>" | sudo tee /var/www/html/app2/index.html
```

Verify locally:

```bash
curl http://localhost/app2/
```

Expected:

```html
<h1>Welcome to APP-2</h1>
```

---

## Step 3 – Create Target Group for App-1

Go to:

```text
EC2 → Target Groups → Create target group
```

Use:

```text
Target type: Instances
Target group name: tg-app1
Protocol: HTTP
Port: 80
VPC: Default VPC
Health check path: /app1/
```

Register only:

```text
Web-1
```

Create the Target Group.

---

## Step 4 – Create Target Group for App-2

Create another Target Group:

```text
Target type: Instances
Target group name: tg-app2
Protocol: HTTP
Port: 80
VPC: Default VPC
Health check path: /app2/
```

Register only:

```text
Web-2
```

Create the Target Group.

---

## Step 5 – Create Listener Rule for App-1

Go to:

```text
EC2 → Load Balancers → web-alb → Listeners and rules
```

Open:

```text
HTTP:80
```

Click:

```text
Manage rules
```

Click:

```text
Add rule
```

Condition:

```text
Path
/app1/*
```

Action:

```text
Forward to target group
tg-app1
```

Save the rule.

---

## Step 6 – Create Listener Rule for App-2

Create another rule.

Condition:

```text
Path
/app2/*
```

Action:

```text
Forward to target group
tg-app2
```

Save the rule.

---

## Step 7 – Test Path-Based Routing

Open:

```text
http://ALB-DNS/app1/
```

Expected:

```text
Welcome to APP-1
```

Open:

```text
http://ALB-DNS/app2/
```

Expected:

```text
Welcome to APP-2
```

This confirms:

```text
/app1/* → tg-app1 → Web-1
/app2/* → tg-app2 → Web-2
```

---

# Part 10 – Multiple Paths to Same Target Group

## Step 1 – Create Image Path on Web-1

Run:

```bash
sudo mkdir -p /var/www/html/image
echo "<h1>Image Application - Web1</h1>" | sudo tee /var/www/html/image/index.html
```

Verify:

```bash
curl http://localhost/image/
```

---

## Step 2 – Create New Listener Rule

Condition:

```text
/image/*
```

Action:

```text
Forward to tg-app1
```

Open:

```text
http://ALB-DNS/image/
```

Expected:

```text
Image Application - Web1
```

---

## Step 3 – Create Same Path on Web-2

Run on Web-2:

```bash
sudo mkdir -p /var/www/html/image
echo "<h1>Image Application - Web2</h1>" | sudo tee /var/www/html/image/index.html
```

---

## Step 4 – Change Listener Rule

Edit the `/image/*` rule.

Change action from:

```text
tg-app1
```

to:

```text
tg-app2
```

Save.

Refresh:

```text
http://ALB-DNS/image/
```

Expected:

```text
Image Application - Web2
```

This proves that ALB listener rules decide where the traffic is forwarded.

---

# Important Commands Used

```bash
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl stop apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```

```bash
sudo mkdir -p /var/www/html/app1
sudo mkdir -p /var/www/html/app2
sudo mkdir -p /var/www/html/image
```

```bash
curl http://localhost/app1/
curl http://localhost/app2/
curl http://localhost/image/
```

---

# AWS Application Load Balancer (ALB) - Complete Hands-on Lab

## Lab Overview

In this lab, we performed a complete production-style ALB setup including:

- Domain Purchase (GoDaddy)
- Route 53 Hosted Zone
- Nameserver Configuration
- ACM SSL Certificate
- Application Load Balancer
- HTTP to HTTPS Redirect
- Path Based Routing
- Host Based Routing
- Network Load Balancer (Basic)

---

# Architecture

```text
                 GoDaddy Domain
                        │
                        ▼
                 Route 53 Hosted Zone
                        │
                        ▼
                ACM SSL Certificate
                        │
                        ▼
          Application Load Balancer (ALB)
                 │                 │
           HTTP :80          HTTPS :443
                │                 │
      Redirect to HTTPS      Listener Rules
                │                 │
                └──────────┬──────┘
                           ▼
                    Target Groups
                           │
                           ▼
                        EC2 Instances
```

---

# Step 1 - Purchase Domain

Purchased Domain from GoDaddy

Example:

```
devopsclasses.space
```

---

# Step 2 - Create Hosted Zone

AWS

Route53

↓

Hosted Zones

↓

Create Hosted Zone

Domain

```
devopsclasses.space
```

Type

```
Public Hosted Zone
```

---

# Step 3 - Update Nameservers in GoDaddy

Copy Route53 Nameservers

Example

```
ns-1517.awsdns-61.org
ns-1913.awsdns-47.co.uk
ns-548.awsdns-04.net
ns-401.awsdns-50.com
```

GoDaddy

↓

Domain

↓

Nameservers

↓

Replace Default Nameservers

↓

Save

---

# Step 4 - Create ACM Certificate

AWS

↓

Certificate Manager

↓

Request Certificate

↓

Public Certificate

Domain

```
devopsclasses.space
*.devopsclasses.space
```

Validation

```
DNS Validation
```

Create Record in Route53

Wait until

```
Issued
```

---

# Step 5 - Create Target Group

Target Type

```
Instance
```

Protocol

```
HTTP
```

Port

```
80
```

Health Check

```
/
```

Register EC2 Instances

---

# Step 6 - Create Application Load Balancer

Type

```
Internet Facing
```

Listener

```
HTTPS :443
```

Attach

```
ACM Certificate
```

Default Action

```
Forward to web-tg
```

Create ALB

---

# Step 7 - Route53 Alias Record

Hosted Zone

↓

Create Record

Type

```
A
```

Alias

```
Yes
```

Target

```
Application Load Balancer
```

Now website becomes

```
https://devopsclasses.space
```

---

# Step 8 - Add HTTP Listener

Add Listener

```
HTTP :80
```

Action

```
Redirect to HTTPS
```

Configuration

```
Protocol : HTTPS
Port : 443
Status : 301
```

Now

```
http://devopsclasses.space
```

Automatically redirects to

```
https://devopsclasses.space
```

---

# Why Port 80?

Without Port 80

```
http://domain.com
```

Fails.

With Port 80

```
HTTP

↓

Redirect

↓

HTTPS

↓

Website
```

Production Best Practice

```
HTTP :80

↓

301 Redirect

↓

HTTPS :443
```

---

# Step 9 - Path Based Routing

Created Target Groups

```
tg-app1
tg-app2
```

Health Check

```
/app1/
/app2/
```

HTTPS Listener Rules

Rule 1

```
IF

Path

/app1/*

↓

Forward

tg-app1
```

Rule 2

```
IF

Path

/app2/*

↓

Forward

tg-app2
```

Default

```
Forward

web-tg
```

Testing

```
https://devopsclasses.space/app1
```

↓

App-1

```
https://devopsclasses.space/app2
```

↓

App-2

---

# Path Based Routing

Routes request using

```
URL Path
```

Example

```
/app1

/app2

/images

/api
```

---

# Step 10 - Host Based Routing

Create Route53 Records

```
app.devopsclasses.space

admin.devopsclasses.space
```

Type

```
A Alias
```

Target

```
Same ALB
```

HTTPS Listener Rules

Rule 1

```
Host Header

app.devopsclasses.space

↓

Forward

tg-app1
```

Rule 2

```
Host Header

admin.devopsclasses.space

↓

Forward

tg-app2
```

Testing

```
https://app.devopsclasses.space
```

↓

App-1

```
https://admin.devopsclasses.space
```

↓

App-2

---

# Host Based Routing

Routes request using

```
Host Name

or

Sub Domain
```

Examples

```
app.company.com

admin.company.com

api.company.com
```

---

# Path vs Host Based

## Path Based

```
https://domain.com/app1

↓

Path

/app1

↓

tg-app1
```

## Host Based

```
https://app.domain.com

↓

Host

app.domain.com

↓

tg-app1
```

---

# HTTP vs HTTPS

HTTP

```
Port 80

Not Encrypted
```

HTTPS

```
Port 443

Encrypted

SSL Certificate
```

---

# HTTP to HTTPS Flow

```
User

↓

http://domain.com

↓

HTTP :80 Listener

↓

Redirect

↓

HTTPS :443 Listener

↓

Target Group

↓

EC2
```

---

# ALB vs NLB

| ALB | NLB |
|------|------|
| Layer 7 | Layer 4 |
| HTTP/HTTPS | TCP/UDP |
| Path Based | No |
| Host Based | No |
| SSL Supported | TLS |
| Static IP | Yes |
| Web Applications | High Performance Applications |

---

# NLB Hands-on

Create Target Group

```
Protocol

TCP
```

Port

```
80
```

Register EC2

Create NLB

Listener

```
TCP :80
```

Forward

```
TCP Target Group
```

---

# Interview Questions

## Why ALB?

ALB works at Layer 7 and supports intelligent routing like Path Based and Host Based Routing.

---

## Why NLB?

NLB works at Layer 4 and is used for high performance and low latency applications.

---

## Why HTTPS?

HTTPS encrypts communication between client and Load Balancer.

---

## Why ACM?

ACM manages SSL/TLS certificates and attaches them to the Load Balancer.

---

## Why Route53?

Route53 maps the domain name to the Application Load Balancer.

---

## Why Port 80 if HTTPS already exists?

Port 80 is used only to redirect users from HTTP to HTTPS.

---

## Difference Between Forward and Redirect

Forward

```
ALB forwards request directly to Target Group.
```

Redirect

```
ALB asks the client/browser to send a new request to another URL (HTTP → HTTPS).
```

---

## Difference Between Path Based and Host Based Routing

Path Based

```
Routes traffic using URL Path.
```

Host Based

```
Routes traffic using Host Name or Sub Domain.
```

---

# Production Flow

```
Internet

↓

Route53

↓

Application Load Balancer

↓

HTTP :80

↓

Redirect

↓

HTTPS :443

↓

Path / Host Based Rules

↓

Target Groups

↓

EC2 Instances
```

# End of ALB Module
