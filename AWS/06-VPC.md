# AWS VPC - Day 01

> In this module, we will learn the fundamentals of Amazon VPC, why it is required, the difference between Default and Custom VPC, CIDR, Subnets, and create our own custom VPC from scratch.

---


# What is Amazon VPC?

Amazon VPC (Virtual Private Cloud) is a logically isolated virtual network inside AWS where we can launch AWS resources like:

- EC2
- RDS
- Load Balancer
- Lambda
- ECS
- EKS

A VPC gives complete control over your network such as:

- IP Address Range
- Subnets
- Route Tables
- Internet Connectivity
- Security
- Network Isolation

Think of a VPC as your own private data center inside AWS.

---

# Why do we need VPC?

Without VPC, every server would be in a common network, making it difficult to secure applications.

Using VPC we can:

- Isolate applications
- Create Public and Private Networks
- Secure databases
- Control inbound and outbound traffic
- Connect AWS with On-Premises
- Design Production Architecture

---

# Default VPC vs Custom VPC

| Default VPC | Custom VPC |
|-------------|------------|
| Created automatically by AWS | Created manually by user |
| Ready to use | Fully customizable |
| Public subnets already available | You create your own subnets |
| Internet Gateway already attached | IGW must be attached manually |
| Suitable for testing | Suitable for production |

---

# CIDR Block

CIDR (Classless Inter-Domain Routing) defines the IP address range of a VPC.

Example:

```
10.0.0.0/16
```

Meaning

```
Network Address : 10.0.0.0

Subnet Mask

255.255.0.0
```

Total IPs

```
65,536
```

AWS reserves the first four IP addresses and the last IP address in every subnet.

Example

```
10.0.1.0/24

Reserved

10.0.1.0
10.0.1.1
10.0.1.2
10.0.1.3
10.0.1.255
```

Usable IPs

```
251
```

---

# VPC Architecture

```
                    AWS Cloud
                         │
        ┌────────────────────────────────┐
        │         Custom VPC             │
        │         10.0.0.0/16            │
        │                                │
        │   Public Subnet                │
        │   10.0.1.0/24                  │
        │                                │
        │   Private Subnet               │
        │   10.0.2.0/24                  │
        └────────────────────────────────┘
```

---

# Public Subnet

A Public Subnet is a subnet that has a route to the Internet Gateway.

Resources generally placed here:

- Bastion Host
- Public EC2
- Application Load Balancer
- NAT Gateway

Example

```
Public Subnet

10.0.1.0/24
```

---

# Private Subnet

A Private Subnet does NOT have a direct route to the Internet Gateway.

Resources generally placed here:

- Application Server
- Database Server
- Internal Services

Example

```
Private Subnet

10.0.2.0/24
```

---

# Lab Goal

In today's practical we will create:

- One Custom VPC
- One Public Subnet
- One Private Subnet

Architecture:

```
             Custom VPC
           10.0.0.0/16
          /            \
         /              \
 Public Subnet      Private Subnet
 10.0.1.0/24        10.0.2.0/24
```

---

# Prerequisites

Before starting the lab ensure:

- AWS Account is ready
- AWS Console access is available
- Region selected
- EC2 Key Pair already created

---

# Hands-on Lab - Create Custom VPC

In this lab we will create the following resources:

- Custom VPC
- Public Subnet
- Private Subnet

---

# Step 1 - Open VPC Dashboard

Login to AWS Console

Search

```
VPC
```

Open

```
VPC Dashboard
```

---

# Step 2 - Create Custom VPC

Go to

```
VPC
→ Your VPCs
→ Create VPC
```

Select

```
VPC Only
```

Enter

```
Name

Custom-VPC

IPv4 CIDR

10.0.0.0/16

IPv6

None

Tenancy

Default
```

Click

```
Create VPC
```

---

# Verify

After creation verify

```
State

Available
```

CIDR

```
10.0.0.0/16
```

---

# Production Note

Always choose a CIDR that will not overlap with:

- Another AWS VPC
- On-Premises Network
- Future AWS Accounts

Changing CIDR later is difficult.

---

# Step 3 - Create Public Subnet

Go to

```
Subnets

Create Subnet
```

Select

```
VPC

Custom-VPC
```

Enter

```
Subnet Name

Public-Subnet

Availability Zone

ap-south-1a

IPv4 CIDR

10.0.1.0/24
```

Click

```
Create Subnet
```

---

# Verify

Check

```
Subnet

Public-Subnet

CIDR

10.0.1.0/24
```

---

# Why Public Subnet?

Resources placed here require direct Internet access.

Examples

- Bastion Host
- Load Balancer
- NAT Gateway
- Public EC2

---

# Step 4 - Create Private Subnet

Again click

```
Create Subnet
```

Enter

```
Subnet Name

Private-Subnet

Availability Zone

ap-south-1b

IPv4 CIDR

10.0.2.0/24
```

Click

```
Create Subnet
```

---

# Verify

```
Private-Subnet

10.0.2.0/24
```

---

# Why Private Subnet?

Private Subnet is used for resources that should not be accessible from the Internet.

Examples

- Application Server
- Database Server
- Internal APIs
- Backend Services

---

# Verify VPC Architecture

```
                Custom-VPC
               10.0.0.0/16
                      │
        ┌─────────────┴─────────────┐
        │                           │
        │                           │
 Public-Subnet               Private-Subnet
 10.0.1.0/24                  10.0.2.0/24
```

---

# What We Created

✔ Custom VPC

```
10.0.0.0/16
```

✔ Public Subnet

```
10.0.1.0/24
```

✔ Private Subnet

```
10.0.2.0/24
```

---

# AWS Console Navigation

```
AWS Console

↓

VPC

↓

Your VPCs

↓

Subnets
```

---

# Best Practices

- Keep databases in Private Subnet.
- Use Public Subnet only for Internet-facing resources.
- Plan CIDR before creating the VPC.
- Use meaningful resource names.
- Create separate subnets for different Availability Zones.

---

# Common Mistakes

❌ Using overlapping CIDR ranges.

❌ Creating everything in Public Subnet.

❌ Not planning IP ranges before deployment.

❌ Using Default VPC for Production.

---

# Hands-on Lab - Internet Gateway & Route Table

Now that our VPC and Subnets are ready, the next step is to provide Internet access to the Public Subnet.

---

# Current Architecture

```
                Custom-VPC
               10.0.0.0/16
                      │
        ┌─────────────┴─────────────┐
        │                           │
 Public-Subnet               Private-Subnet
 10.0.1.0/24                  10.0.2.0/24
```

Currently,

❌ No Internet Access

Reason:

- No Internet Gateway
- No Public Route

---

# Step 5 - Create Internet Gateway

Go to

```
VPC

↓

Internet Gateways

↓

Create Internet Gateway
```

Enter

```
Name

Custom-IGW
```

Click

```
Create Internet Gateway
```

---

# Verify

Status

```
Detached
```

This is normal because it is not attached to any VPC.

---

# Step 6 - Attach Internet Gateway

Select

```
Custom-IGW
```

Click

```
Actions

↓

Attach to VPC
```

Select

```
Custom-VPC
```

Click

```
Attach
```

---

# Verify

Internet Gateway

```
State

Attached
```

VPC

```
Custom-VPC
```

---

# Architecture

```
                 Internet
                     │
                     │
             Internet Gateway
                     │
             Custom-VPC
            10.0.0.0/16
```

---

# Why Internet Gateway?

Internet Gateway provides communication between

- AWS VPC
- Internet

Without Internet Gateway,

- Public EC2 cannot access Internet.
- Internet users cannot access Public EC2.

---

# Step 7 - Create Public Route Table

Go to

```
VPC

↓

Route Tables

↓

Create Route Table
```

Enter

```
Name

Public-RT

VPC

Custom-VPC
```

Click

```
Create Route Table
```

---

# Verify

```
Route Table

Public-RT
```

---

# Step 8 - Add Internet Route

Open

```
Public-RT
```

Go to

```
Routes

↓

Edit Routes

↓

Add Route
```

Enter

```
Destination

0.0.0.0/0

Target

Internet Gateway

Custom-IGW
```

Click

```
Save Changes
```

---

# Route Table

```
Destination         Target

10.0.0.0/16         local

0.0.0.0/0           Internet Gateway
```

---

# What does 0.0.0.0/0 mean?

```
0.0.0.0/0
```

Means

```
Anywhere

Any IPv4 Address

Entire Internet
```

Whenever AWS cannot find a local route,

Traffic is forwarded to

```
Internet Gateway
```

---

# Step 9 - Associate Route Table

Open

```
Public-RT
```

Go to

```
Subnet Associations

↓

Edit Subnet Associations
```

Select

```
Public-Subnet
```

Click

```
Save
```

---

# Verify

Associated Subnet

```
Public-Subnet
```

---

# Architecture

```
                  Internet
                      │
                      │
              Internet Gateway
                      │
                Public Route
             0.0.0.0/0 → IGW
                      │
             Public Route Table
                      │
              Public Subnet
```

---

# Why Private Subnet is NOT Associated?

Private subnet should never have

```
0.0.0.0/0

↓

Internet Gateway
```

Otherwise,

Private EC2 will become Internet accessible.

---

# Production Note

Always create

- Separate Route Table for Public Subnet
- Separate Route Table for Private Subnet

Never use one Route Table for everything.

---

# Best Practices

✔ Separate Route Tables

✔ Meaningful Names

✔ Verify Route Target

✔ Keep Database in Private Subnet

✔ Review Associations before Launching EC2

---

# Common Mistakes

❌ Forgot to attach Internet Gateway

❌ Forgot Route Table Association

❌ Added wrong Target

❌ Associated Private Subnet with Public Route Table

❌ Deleted Local Route (AWS does not allow this)

---
# Hands-on Lab - Launch Public EC2 Instance

Now our VPC network is ready.

Next, we will launch a Public EC2 instance inside the Public Subnet and verify Internet connectivity.

---

# Current Architecture

```
                   Internet
                       │
                Internet Gateway
                       │
              Public Route Table
                       │
                Public Subnet
                10.0.1.0/24
```

---

# Step 10 - Launch EC2

Go to

```
AWS Console

↓

EC2

↓

Launch Instance
```

---

# Step 11 - Configure Instance

Instance Name

```
Public-Server
```

AMI

```
Ubuntu Server 24.04 LTS
```

Instance Type

```
t2.micro
```

Key Pair

```
Select Existing Key Pair
```

---

# Step 12 - Select Network

Network

```
Custom-VPC
```

Subnet

```
Public-Subnet
```

Auto Assign Public IP

```
Enable
```

This is very important.

If disabled,

EC2 will not receive a Public IP.

---

# Step 13 - Create Security Group

Create New Security Group

```
Public-SG
```

Inbound Rules

```
SSH
Port 22
Source
My IP
```

```
HTTP
Port 80
Source
0.0.0.0/0
```

```
HTTPS
Port 443
Source
0.0.0.0/0
```

Outbound

```
Allow All
```

Launch Instance.

---

# Verify EC2

Check

```
State

Running
```

Status Checks

```
2/2 Checks Passed
```

Network

```
Public IPv4

Available
```

```
Private IPv4

10.0.1.x
```

---

# Step 14 - Connect to EC2

Open Terminal

Move to Key Pair location

```
cd Downloads
```

Change Permission

```bash
chmod 400 mykey.pem
```

Connect

```bash
ssh -i mykey.pem ubuntu@PUBLIC_IP
```

Example

```bash
ssh -i mykey.pem ubuntu@13.xxx.xxx.xxx
```

---

# Verify Login

Check

```bash
hostname
```

```bash
hostnamectl
```

```bash
whoami
```

Expected

```
ubuntu
```

---

# Step 15 - Verify Internet

Check Public IP

```bash
curl ifconfig.me
```

Output

```
13.xxx.xxx.xxx
```

---

Check Connectivity

```bash
ping google.com
```

Expected

```
64 bytes from...
```

---

Update Packages

```bash
sudo apt update
```

If packages are downloading successfully,

Internet is working correctly.

---

# Step 16 - Verify Network

Check Interface

```bash
ip a
```

Check Routing

```bash
ip route
```

Expected

```
default via
```

---

# Final Architecture

```
                    Internet
                        │
                        │
                Internet Gateway
                        │
             Public Route Table
         0.0.0.0/0 → Internet Gateway
                        │
                Public Subnet
                  10.0.1.0/24
                        │
                 Public EC2
        Public IP + Private IP
```

---

# Commands Used

```bash
ssh
```

```bash
chmod 400
```

```bash
hostname
```

```bash
hostnamectl
```

```bash
whoami
```

```bash
ip a
```

```bash
ip route
```

```bash
curl ifconfig.me
```

```bash
ping google.com
```

```bash
sudo apt update
```

---

# AWS VPC - Day 02

> In this module, we will build a production-style VPC by creating a NAT Gateway, configuring Public and Private Route Tables, launching a Private EC2 instance, and understanding how Internet access works for private resources.

---

# Table of Contents

- NAT Gateway
- Elastic IP
- Public Route Table
- Private Route Table
- Launch Private EC2
- Verify NAT
- Bastion Host
- Security Group
- NACL

---

# Lab Architecture

```
                         Internet
                             │
                     Internet Gateway
                             │
                     Public Route Table
                  0.0.0.0/0 → IGW
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
         │                                       │
 Public Subnet                          Private Subnet
 10.0.1.0/24                             10.0.2.0/24
         │                                       │
         │                                       │
     NAT Gateway                           Private EC2
         │
     Elastic IP
```

---

# Why NAT Gateway?

A Private EC2 should be able to:

- Download Packages
- Install Software
- Access AWS APIs
- Download Updates

But...

It should NOT be accessible from the Internet.

AWS solves this problem using

```
NAT Gateway
```

---

# How NAT Works

```
Private EC2

↓

Private Route Table

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

Traffic Flow

```
Outbound

Allowed

Inbound

Blocked
```

---

# Step 1 - Allocate Elastic IP

Go to

```
VPC

↓

Elastic IPs

↓

Allocate Elastic IP Address
```

Click

```
Allocate
```

---

# Verify

```
Elastic IP

Allocated
```

Copy the Elastic IP.

We will use it while creating NAT Gateway.

---

# Why Elastic IP?

A NAT Gateway always requires

```
Static Public IP
```

AWS provides that using

```
Elastic IP
```

---

# Step 2 - Create NAT Gateway

Go to

```
VPC

↓

NAT Gateways

↓

Create NAT Gateway
```

Enter

```
Name

My-NAT
```

Subnet

```
Public-Subnet
```

Connectivity

```
Public
```

Elastic IP

```
Select Allocated EIP
```

Click

```
Create NAT Gateway
```

---

# Verify

Status

```
Available
```

This may take a few minutes.

---

# Important

NAT Gateway must always be created inside

```
Public Subnet
```

Never create it inside Private Subnet.

---

# Step 3 - Create Private Route Table

Go to

```
Route Tables

↓

Create Route Table
```

Enter

```
Name

Private-RT

VPC

Custom-VPC
```

Click

```
Create
```

---

# Step 4 - Add NAT Route

Open

```
Private-RT
```

Go to

```
Routes

↓

Edit Routes

↓

Add Route
```

Enter

```
Destination

0.0.0.0/0
```

Target

```
NAT Gateway

My-NAT
```

Click

```
Save Changes
```

---

# Route Table

```
Destination

10.0.0.0/16

↓

Local

-------------------------

0.0.0.0/0

↓

NAT Gateway
```

---

# Step 5 - Associate Private Route Table

Open

```
Private-RT
```

Go to

```
Subnet Associations

↓

Edit Associations
```

Select

```
Private-Subnet
```

Click

```
Save
```

---

# Verify

```
Private Subnet

↓

Private Route Table

↓

NAT Gateway
```

Connection completed.

---

# Current Architecture

```
                       Internet
                           │
                   Internet Gateway
                           │
             ┌─────────────┴─────────────┐
             │                           │
      Public Route Table          Private Route Table
      0.0.0.0 → IGW              0.0.0.0 → NAT
             │                           │
      Public Subnet              Private Subnet
             │                           │
      NAT Gateway                 Private EC2
```

---
# Hands-on Lab - Launch Private EC2 & Verify NAT Gateway

Now our Private Route Table is connected to the NAT Gateway.

Next, we will launch a Private EC2 instance and verify Internet connectivity.

---

# Current Architecture

```
                        Internet
                            │
                    Internet Gateway
                            │
                    Public Route Table
                     0.0.0.0/0 → IGW
                            │
         ┌──────────────────┴──────────────────┐
         │                                     │
    Public Subnet                        Private Subnet
     10.0.1.0/24                         10.0.2.0/24
         │                                     │
    NAT Gateway                         Private EC2
```

---

# Step 6 - Launch Private EC2

Go to

```
EC2

↓

Launch Instance
```

---

# Configure Instance

Instance Name

```
Private-Server
```

AMI

```
Ubuntu Server 24.04 LTS
```

Instance Type

```
t2.micro
```

Key Pair

```
Select Existing Key Pair
```

---

# Network Settings

VPC

```
Custom-VPC
```

Subnet

```
Private-Subnet
```

Auto Assign Public IP

```
Disable
```

Very Important

Private EC2 should NEVER receive a Public IP.

---

# Security Group

Create

```
Private-SG
```

Inbound Rules

```
SSH

Port 22

Source

Public-SG
```

or

```
Source

Bastion Security Group
```

Outbound

```
Allow All
```

Launch Instance.

---

# Verify

Check

```
Private IPv4

10.0.2.x
```

Public IP

```
None
```

This confirms the EC2 is private.

---

# Step 7 - Connect to Private EC2

Since there is no Public IP,

SSH from Laptop

❌ Not Possible

Need

```
Bastion Host
```

or

```
AWS Systems Manager
```

---

# Method 1 - SSH Using Bastion Host

Login to Public EC2

```bash
ssh -i mykey.pem ubuntu@PUBLIC_IP
```

Copy Key

```bash
scp -i mykey.pem mykey.pem ubuntu@PUBLIC_IP:/home/ubuntu
```

Login to Bastion

```bash
ssh -i mykey.pem ubuntu@PUBLIC_IP
```

Change Permission

```bash
chmod 400 mykey.pem
```

Now SSH into Private EC2

```bash
ssh -i mykey.pem ubuntu@10.0.2.x
```

Connected Successfully.

---

# Step 8 - Verify Internet Access

Inside Private EC2

Run

```bash
ping google.com
```

Expected

```
64 bytes from...
```

---

Check

```bash
sudo apt update
```

Packages should download successfully.

---

Check Public IP

```bash
curl ifconfig.me
```

Output

```
Elastic IP of NAT Gateway
```

Notice

Private EC2 does NOT have a Public IP,

but Internet traffic goes through the NAT Gateway.

---

# Verify Routing

Run

```bash
ip route
```

Expected

```
default via
```

Traffic reaches the subnet gateway, and AWS routes it to the NAT Gateway based on the VPC Route Table.

---

# Traffic Flow

```
Private EC2

↓

Private Route Table

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

Return Traffic

```
Internet

↓

NAT Gateway

↓

Private EC2
```

Unsolicited inbound traffic from the Internet is NOT allowed.

---

# Verification Checklist

✅ Private EC2 Created

✅ No Public IP

✅ Private Route Table Associated

✅ NAT Gateway Available

✅ SSH via Bastion

✅ Internet Working

✅ apt update Successful

---

# Commands Used

```bash
ssh
```

```bash
scp
```

```bash
chmod 400
```

```bash
ping google.com
```

```bash
curl ifconfig.me
```

```bash
sudo apt update
```

```bash
ip route
```

---

# AWS VPC - Day 03

> In this module, we will learn advanced VPC networking features used in production environments:
>
> - VPC Peering
> - VPC Endpoints
> - Flow Logs
> - Transit Gateway
> - Site-to-Site VPN
> - AWS Direct Connect

---

# Table of Contents

- VPC Peering
- Gateway Endpoint
- Interface Endpoint
- VPC Flow Logs
- Transit Gateway
- Site-to-Site VPN
- AWS Direct Connect

---

# VPC Peering

VPC Peering is used to privately connect two VPCs.

Resources communicate using

```
Private IP Address
```

No Internet Gateway is required.

---

# Lab Architecture

```
          Default VPC
      172.31.0.0/16
             │
             │
     VPC Peering Connection
             │
             │
       Custom VPC
       10.0.0.0/16
```

---

# Step 1 - Create Peering Connection

Go to

```
VPC

↓

Peering Connections

↓

Create Peering Connection
```

Enter

```
Name

Default-To-Custom
```

Requester

```
Default VPC
```

Accepter

```
Custom VPC
```

Click

```
Create
```

---

# Step 2 - Accept Request

Select

```
Peering Connection
```

Click

```
Actions

↓

Accept Request
```

---

# Step 3 - Update Route Tables

Default Route Table

Add

```
Destination

10.0.0.0/16

↓

Target

Peering Connection
```

---

Custom Route Table

Add

```
Destination

172.31.0.0/16

↓

Target

Peering Connection
```

---

# Step 4 - Update Security Group

Allow

```
All ICMP

Source

Other VPC CIDR
```

---

# Step 5 - Verify

From EC2

```bash
ping PRIVATE_IP
```

Expected

```
0% Packet Loss
```

---

# VPC Endpoint

A VPC Endpoint allows private access to AWS services without using:

- Internet Gateway
- NAT Gateway
- Public IP

---

# Types

## Gateway Endpoint

Supports

```
Amazon S3

Amazon DynamoDB
```

---

## Interface Endpoint

Supports

- EC2 API
- SSM
- SNS
- CloudWatch
- Secrets Manager
- Many AWS Services

---

# Gateway Endpoint Practical

Go to

```
VPC

↓

Endpoints

↓

Create Endpoint
```

Select

```
AWS Services
```

Choose

```
Amazon S3
```

Type

```
Gateway
```

Select

```
Custom VPC
```

Choose

```
Private Route Table
```

Click

```
Create
```

---

# Verify

Inside EC2

```bash
aws s3 ls
```

Traffic goes privately through AWS Network.

---

# VPC Flow Logs

Flow Logs capture network traffic metadata.

Can be created for

- VPC
- Subnet
- ENI

Destination

- CloudWatch
- Amazon S3

---

# Create Flow Log

Go to

```
VPC

↓

Your VPC

↓

Flow Logs

↓

Create Flow Log
```

Choose

```
Destination

CloudWatch
```

Create Log Group

```
/aws/vpc/flowlogs
```

Click

```
Create
```

---

# Verify

Generate traffic

```bash
ping google.com
```

or

```bash
curl google.com
```

Open

```
CloudWatch

↓

Log Groups

↓

/aws/vpc/flowlogs
```

Check

```
ACCEPT

REJECT
```

---

# Transit Gateway

Transit Gateway acts as a central router for multiple VPCs.

Instead of

```
VPC A

↔

VPC B

↔

VPC C
```

We create

```
              Transit Gateway
             /       |        \
            /        |         \
         VPC A    VPC B     VPC C
```

---

# Lab

We connected

```
Default VPC

↓

Transit Gateway

↓

Custom VPC
```

---

# Step 1

Create

```
Transit Gateway
```

Name

```
My-TGW
```

---

# Step 2

Create Attachment

```
Default VPC
```

---

# Step 3

Create Attachment

```
Custom VPC
```

---

# Step 4

Update Route Table

Default VPC

```
10.0.0.0/16

↓

Transit Gateway
```

---

Custom VPC

```
172.31.0.0/16

↓

Transit Gateway
```

---

# Step 5

Allow

```
ICMP
```

inside Security Group.

---

# Verify

From Default EC2

```bash
ping 10.0.1.53
```

Output

```
4 transmitted

4 received

0% packet loss
```

Communication successful.

---

# Site-to-Site VPN

Used to connect

```
On-Premises

↓

AWS VPC
```

using

```
Encrypted IPSec Tunnel
```

Architecture

```
Office

↓

Customer Gateway

↓

VPN Tunnel

↓

AWS VPN Gateway

↓

VPC
```

---

# AWS Direct Connect

Provides

```
Dedicated Private Connection
```

between

```
Office

↓

AWS
```

No Internet involved.

Benefits

- Low Latency
- High Bandwidth
- Stable Connection

---

# Verification Commands

```bash
ping
```

```bash
ip route
```

```bash
curl
```

```bash
aws s3 ls
```

---

# Final VPC Architecture

```
                       Internet
                           │
                    Internet Gateway
                           │
              ┌────────────┴────────────┐
              │                         │
      Public Route Table         Private Route Table
              │                         │
        Public Subnet             Private Subnet
              │                         │
          NAT Gateway              Private EC2
              │
          Public EC2

                   │
        ───────────────────────

          Transit Gateway

        ───────────────────────

         Default VPC

        ───────────────────────

     Site-to-Site VPN

        ───────────────────────

      On-Premises Network

        ───────────────────────

       AWS Direct Connect
```

---





