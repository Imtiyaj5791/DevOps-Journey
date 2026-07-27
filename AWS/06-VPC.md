# AWS VPC — Day 01

## Topics Covered

1. VPC Basics
2. CIDR Block
3. Public vs Private Subnet
4. Internet Gateway
5. Route Table
6. Main vs Custom Route Table
7. Security Group vs NACL
8. Public Subnet Hands-on Lab
9. Private Subnet Hands-on Lab
10. Public EC2 to Private EC2 SSH
11. Bastion / Jump Host Concept
12. Troubleshooting
13. Interview Questions & Answers

---

# 1. What is a VPC?

VPC stands for **Virtual Private Cloud**.

A VPC is a logically isolated virtual network in AWS where we can create and manage our own network resources.

Inside a VPC, we can configure:

- IP address ranges
- Subnets
- Route Tables
- Internet Gateway
- Security Groups
- NACLs
- EC2 instances

Basic architecture:

```text
VPC
│
├── Public Subnet
│     └── Web Server
│
└── Private Subnet
      └── Database / Backend Server
```

---

# 2. CIDR Block

CIDR defines the IP address range of a VPC or subnet.

Example:

```text
VPC CIDR = 10.0.0.0/16
```

A `/16` network contains:

```text
65,536 total IP addresses
```

We can divide this VPC into smaller subnets.

Example:

```text
VPC = 10.0.0.0/16

├── Public Subnet
│     10.0.1.0/24
│
└── Private Subnet
      10.0.2.0/24
```

A `/24` subnet contains:

```text
256 total IP addresses
```

AWS reserves 5 IP addresses in every subnet.

Therefore:

```text
/24 = 256 total IP addresses
       251 available for resources
```

## CIDR Boundary

Valid subnet examples:

```text
10.0.0.0/24
10.0.1.0/24
10.0.2.0/24
```

We cannot define a `/24` subnet as:

```text
10.0.0.1/24
```

because `10.0.0.1` is an address inside the `10.0.0.0/24` network rather than the `/24` network address.

---

# 3. Public vs Private Subnet

## Public Subnet

A subnet is considered public when its Route Table has a route to an Internet Gateway.

Example:

```text
Destination      Target

10.0.0.0/16      local
0.0.0.0/0        IGW
```

For an EC2 instance in that subnet to communicate directly with the internet over IPv4, it also needs a public IPv4 address and appropriate security rules.

Architecture:

```text
Internet
   |
   |
  IGW
   |
Public Route Table
   |
Public Subnet
   |
Public EC2
```

---

## Private Subnet

A private subnet does not have a direct route to an Internet Gateway.

Example:

```text
Destination      Target

10.0.0.0/16      local
```

Private subnets are commonly used for:

- Database servers
- Backend servers
- Application servers
- Internal services

Example:

```text
Public Subnet
     |
 Web Server
     |
Private Subnet
     |
 Database
```

---

# 4. Internet Gateway — IGW

An Internet Gateway enables communication between resources in a VPC and the internet.

Architecture:

```text
Internet
   |
   |
  IGW
   |
  VPC
   |
Public Subnet
   |
  EC2
```

The Internet Gateway must first be attached to the VPC.

However, simply attaching an IGW does not make a subnet public.

The subnet's Route Table must contain:

```text
0.0.0.0/0 → IGW
```

---

# 5. Route Table

A Route Table determines where network traffic should be directed based on its destination.

Example:

```text
Destination      Target

10.0.0.0/16      local
0.0.0.0/0        IGW
```

## Local Route

```text
10.0.0.0/16 → local
```

This allows routing within the VPC CIDR.

## Internet Route

```text
0.0.0.0/0 → IGW
```

This sends matching IPv4 traffic towards the Internet Gateway.

Example flow:

```text
EC2
 ↓
Route Table
 ↓
0.0.0.0/0
 ↓
IGW
 ↓
Internet
```

---

# 6. Main vs Custom Route Table

When we create a VPC, AWS automatically creates a **Main Route Table**.

We can also create custom Route Tables.

Example:

```text
VPC
│
├── Public Route Table
│      ├── Public-Subnet-1
│      ├── Public-Subnet-2
│      └── Public-Subnet-3
│
└── Private Route Table
       ├── Private-Subnet-1
       └── Private-Subnet-2
```

## Important Rule

```text
1 Subnet      → 1 Route Table at a time

1 Route Table → Multiple Subnets
```

Therefore, if three public subnets require the same routing, we can associate all three with the same Public Route Table.

We do not need to create a separate Route Table for every subnet unless their routing requirements are different.

If a subnet is not explicitly associated with a custom Route Table, it uses the VPC's Main Route Table.

---

# 7. Security Group vs NACL

Security Groups and NACLs both control network traffic, but they work at different levels.

| Security Group | NACL |
|---|---|
| Works at ENI/instance level | Works at subnet level |
| Stateful | Stateless |
| Allow rules only | Allow and Deny rules |
| Return traffic for allowed connections is automatically permitted | Inbound and outbound traffic are evaluated separately |
| Rules are evaluated collectively | Rules are evaluated in rule-number order |

## Security Group — Stateful

If traffic is allowed in one direction, response traffic for that established connection is automatically allowed.

Example:

```text
Client
  ↓ Request
Security Group
  ↓
EC2
  ↑ Response
Automatically allowed
```

## NACL — Stateless

Inbound and outbound traffic are evaluated separately.

Example:

```text
Inbound traffic
      ↓
Inbound NACL Rules

Outbound traffic
      ↓
Outbound NACL Rules
```

Required traffic must therefore be allowed by the applicable rules in both directions.

## Easy Revision

```text
SG
= ENI/Instance Level
+ Stateful
+ Allow Rules Only


NACL
= Subnet Level
+ Stateless
+ Allow & Deny Rules
```

---

# 8. VPC Day 1 Hands-on Lab

Today we created the following architecture:

```text
                         INTERNET
                            |
                            |
                         Lab-IGW
                            |
                            |
                 +--------------------+
                 |      Lab-VPC       |
                 |    10.0.0.0/16     |
                 +--------------------+
                     /            \
                    /              \
                   /                \
        Public-Subnet-1          Private-Subnet-1
          10.0.1.0/24             10.0.2.0/24
               |                        |
           Public-RT                Private-RT
               |                        |
          Public EC2               Private EC2
           10.0.1.53                10.0.2.212
```

---

# 9. Create Custom VPC

Created:

```text
Name      → Lab-VPC
IPv4 CIDR → 10.0.0.0/16
Tenancy   → Default
```

---

# 10. Create Public Subnet

Created:

```text
Name      → Public-Subnet-1
VPC       → Lab-VPC
IPv4 CIDR → 10.0.1.0/24
```

---

# 11. Create Internet Gateway

Created:

```text
Name → Lab-IGW
```

Then attached it to:

```text
Lab-VPC
```

Architecture:

```text
Internet
   |
Lab-IGW
   |
Lab-VPC
```

---

# 12. Create Public Route Table

Created:

```text
Name → Public-RT
VPC  → Lab-VPC
```

Associated:

```text
Public-Subnet-1
```

Routes:

```text
Destination      Target

10.0.0.0/16      local
0.0.0.0/0        Lab-IGW
```

The important route is:

```text
0.0.0.0/0 → Lab-IGW
```

This makes the associated subnet a public subnet.

---

# 13. Launch Public EC2

Public EC2 was launched with:

```text
VPC       → Lab-VPC
Subnet    → Public-Subnet-1
Public IP → Enabled
```

Security Group:

```text
Type   → SSH
Port   → 22
Source → My IP
```

Meaning:

```text
My Laptop
    |
    | SSH 22
    ↓
Public EC2
```

Only our configured source IP is allowed to initiate SSH to the Public EC2.

---

# 14. Test Public EC2 Internet Connectivity

After connecting to the Public EC2, we tested internet connectivity.

Command:

```bash
curl -I https://aws.amazon.com
```

Result:

```text
HTTP/2 200
```

This confirmed that our configuration was working:

```text
Public EC2
    ↓
Public-RT
    ↓
0.0.0.0/0
    ↓
Lab-IGW
    ↓
Internet
```

---

# 15. Create Private Subnet

Created:

```text
Name      → Private-Subnet-1
VPC       → Lab-VPC
IPv4 CIDR → 10.0.2.0/24
```

---

# 16. Create Private Route Table

Created:

```text
Name → Private-RT
VPC  → Lab-VPC
```

Associated:

```text
Private-Subnet-1
```

At this stage, the Private Route Table contained the local route:

```text
10.0.0.0/16 → local
```

We did NOT configure:

```text
0.0.0.0/0 → IGW
```

Therefore, the private subnet does not have a direct route to the Internet Gateway.

---

# 17. Launch Private EC2

Private EC2 was launched with:

```text
VPC       → Lab-VPC
Subnet    → Private-Subnet-1
Public IP → Disabled
```

Our Private EC2 received:

```text
Private IP → 10.0.2.212
Public IP  → None
```

Therefore, we cannot directly SSH from our laptop over the internet to this private IP.

---

# 18. Private EC2 Security Group

We created a separate Security Group for the Private EC2.

Inbound rule:

```text
Type   → SSH
Port   → 22
Source → Public EC2 Security Group
```

The important point is that we did NOT configure:

```text
SSH → 0.0.0.0/0
```

for the Private EC2.

Instead:

```text
Laptop
   |
   | SSH 22
   | Source = My IP
   ↓
Public EC2
   |
   | SSH 22
   | Source = Public EC2 SG
   ↓
Private EC2
```

---

# 19. Why SSH Rule Was Required on Both EC2 Security Groups

The two SSH rules serve different purposes.

## Public EC2 Security Group

Controls:

```text
Laptop → Public EC2
```

Rule:

```text
SSH
Port 22
Source = My IP
```

## Private EC2 Security Group

Controls:

```text
Public EC2 → Private EC2
```

Rule:

```text
SSH
Port 22
Source = Public EC2 Security Group
```

Therefore:

```text
Public SG
→ Who can enter Public EC2?

Private SG
→ Who can enter Private EC2?
```

---

# 20. Bastion / Jump Host

The Private EC2 does not have a public IP.

Therefore this will not work directly from our laptop:

```text
Laptop
   ↓
10.0.2.212
```

Instead we used:

```text
Laptop
   ↓
Public EC2
   ↓
Private EC2
```

The Public EC2 acts as a **Bastion / Jump Host** in this lab.

---

# 21. First SSH Attempt to Private EC2

After logging into Public EC2, we tried:

```bash
ssh ubuntu@10.0.2.212
```

We received:

```text
Permission denied (publickey)
```

This was an SSH authentication issue.

The Public EC2 could reach the Private EC2 network path, but the SSH client did not have the required private key for authentication.

---

# 22. Convert PuTTY Key for Linux SSH

Our original key was:

```text
Mumbai.ppk
```

PuTTY uses `.ppk` format.

We opened the key in **PuTTYgen** and exported an OpenSSH-compatible private key.

Flow:

```text
Mumbai.ppk
    ↓
PuTTYgen
    ↓
Export OpenSSH Key
    ↓
Mumbai.pem
```

Now the exported private key could be used with the Linux/OpenSSH `ssh -i` command.

---

# 23. Copy Key from Windows to Public EC2

We used SCP from the Windows machine.

Command:

```bash
scp -i Mumbai.pem Mumbai.pem ubuntu@<PUBLIC-EC2-PUBLIC-IP>:/home/ubuntu/
```

## SCP Syntax

```text
scp -i <authentication-key> <local-file> <user>@<server-ip>:<destination>
```

In our command:

```text
scp -i Mumbai.pem Mumbai.pem ...
       ↑          ↑
       |          |
       |          File being copied
       |
       Authentication key
```

The same filename appeared twice because the first one was used for authentication and the second one was the file being copied.

---

# 24. Set Key Permission

On the Public EC2:

```bash
chmod 400 Mumbai.pem
```

This restricts access to the private key file.

---

# 25. SSH from Public EC2 to Private EC2

From Public EC2:

```bash
ssh -i Mumbai.pem ubuntu@10.0.2.212
```

SSH was successful.

Final connection:

```text
Windows Laptop
      |
      | SSH using Public IP
      ↓
Public EC2
10.0.1.53
      |
      | SSH using Private IP
      ↓
Private EC2
10.0.2.212
```

---

# 26. Production Security Note

For today's learning lab, we temporarily copied the private key to the Public EC2.

This helped us understand:

```text
Laptop
   ↓
Bastion
   ↓
Private Server
```

However, storing private SSH keys on a bastion host is generally not the preferred production approach.

Production environments can use approaches such as:

- AWS Systems Manager Session Manager
- SSH agent forwarding where appropriate
- Properly managed bastion access
- Short-lived access mechanisms

Private keys should not be unnecessarily stored on intermediate servers.

---

# 27. Troubleshooting — Public EC2 Cannot Access Internet

Check the following:

```text
1. Is the EC2 inside the correct Public Subnet?

2. Does the EC2 have a Public IPv4 address?

3. Is an Internet Gateway attached to the VPC?

4. Does the Public Route Table contain:

   0.0.0.0/0 → IGW

5. Is the Public Route Table associated with the correct subnet?

6. Are Security Group rules correct?

7. Are NACL rules blocking the traffic?
```

---

# 28. Troubleshooting — Cannot SSH to Private EC2

Check:

```text
1. Are Public and Private EC2 using networks with a valid route between them?

2. Are you using the correct Private IP?

3. Does Private EC2 SG allow SSH from the Public EC2 SG?

4. Are NACL rules allowing the required traffic?

5. Is the correct username being used?

6. Is the correct SSH private key being used?
```

---

# 29. Day 01 Architecture — Final Revision

```text
                          INTERNET
                             |
                             |
                          Lab-IGW
                             |
                     0.0.0.0/0
                             |
                 +---------------------+
                 |       Lab-VPC       |
                 |     10.0.0.0/16     |
                 +---------------------+
                     /             \
                    /               \
                   /                 \
          PUBLIC SUBNET           PRIVATE SUBNET
           10.0.1.0/24             10.0.2.0/24
                |                        |
            Public-RT                Private-RT
                |                        |
           Public EC2               Private EC2
            10.0.1.53                10.0.2.212
                |                        ↑
                |________________________|
                      SSH Port 22
```

---

# 30. Important Interview Questions & Answers

## Q1. What is a VPC?

**Answer:**

A VPC is a logically isolated virtual network in AWS where we can create and manage our own network resources.

---

## Q2. What is CIDR?

**Answer:**

CIDR defines the IP address range of a VPC or subnet.

Example:

```text
VPC    → 10.0.0.0/16
Subnet → 10.0.1.0/24
```

---

## Q3. How many IP addresses are available in a /24 subnet?

**Answer:**

A `/24` subnet contains 256 total IP addresses.

AWS reserves 5 IP addresses, leaving 251 addresses available for resources.

---

## Q4. What is the difference between a Public and Private Subnet?

**Answer:**

A Public Subnet has a route to an Internet Gateway.

A Private Subnet does not have a direct route to an Internet Gateway.

---

## Q5. What makes a subnet public?

**Answer:**

A subnet is considered public when its associated Route Table contains a route to an Internet Gateway.

Example:

```text
0.0.0.0/0 → IGW
```

---

## Q6. Does attaching an Internet Gateway to a VPC automatically make a subnet public?

**Answer:**

No.

The subnet's Route Table must also have a route pointing to the Internet Gateway.

---

## Q7. What is an Internet Gateway?

**Answer:**

An Internet Gateway enables communication between resources in a VPC and the internet.

For a public subnet, the Route Table normally contains:

```text
0.0.0.0/0 → IGW
```

---

## Q8. What is a Route Table?

**Answer:**

A Route Table determines where network traffic should be directed based on its destination.

Example:

```text
10.0.0.0/16 → local
0.0.0.0/0   → IGW
```

---

## Q9. What is the difference between Main and Custom Route Tables?

**Answer:**

AWS automatically creates a Main Route Table when a VPC is created.

We can create Custom Route Tables and explicitly associate them with specific subnets based on routing requirements.

---

## Q10. Can multiple subnets use the same Route Table?

**Answer:**

Yes.

Multiple subnets can use the same Route Table if they require the same routing.

Example:

```text
Public-RT
   ├── Public-Subnet-1
   ├── Public-Subnet-2
   └── Public-Subnet-3
```

However, one subnet can be associated with only one Route Table at a time.

---

## Q11. What is the difference between Security Group and NACL?

**Answer:**

Security Group works at the ENI/instance level and is stateful.

NACL works at the subnet level and is stateless.

Security Groups support allow rules only, whereas NACLs support both allow and deny rules.

```text
SG
→ ENI/Instance Level
→ Stateful
→ Allow only

NACL
→ Subnet Level
→ Stateless
→ Allow + Deny
```

---

## Q12. What does Stateful mean?

**Answer:**

Stateful means that if traffic is allowed in one direction, response traffic for that established connection is automatically allowed.

Security Groups are stateful.

---

## Q13. What does Stateless mean?

**Answer:**

Stateless means inbound and outbound traffic are evaluated independently.

NACLs are stateless.

---

## Q14. Why did we reference the Public EC2 Security Group in the Private EC2 Security Group?

**Answer:**

We wanted SSH access to the Private EC2 only from the Public EC2.

Therefore, the Private EC2 Security Group contains:

```text
SSH
Port   → 22
Source → Public EC2 Security Group
```

This allows:

```text
Laptop
   ↓
Public EC2
   ↓
Private EC2
```

without opening Private EC2 SSH to the entire internet.

---

## Q15. Why can't we directly SSH to a Private EC2 from the internet?

**Answer:**

A Private EC2 normally does not have a public IP and is not directly reachable from the internet.

We can access it through a controlled method such as a Bastion Host or AWS Systems Manager Session Manager.

---

## Q16. What is a Bastion Host?

**Answer:**

A Bastion Host is a controlled entry point used to access resources located in a private network.

Example:

```text
Laptop
   ↓
Bastion / Public EC2
   ↓
Private EC2
```

---

## Q17. Your Public EC2 has a Public IP but internet is not working. What will you check?

**Answer:**

I will check:

1. Internet Gateway is attached to the VPC.
2. Public Route Table has `0.0.0.0/0 → IGW`.
3. Correct Route Table is associated with the subnet.
4. EC2 has a Public IPv4 address.
5. Security Group rules.
6. NACL rules.

---

## Q18. Public EC2 can reach Private EC2 but SSH shows `Permission denied (publickey)`. What does it indicate?

**Answer:**

It usually indicates an SSH authentication problem rather than a basic network reachability problem.

I will verify:

- Correct username
- Correct private key
- Key permissions
- Instance key pair configuration

---