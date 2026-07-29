# 🌐 VPC Interview Questions - Part 01

---

# Q1. What is Amazon VPC?

## Answer

Amazon VPC (Virtual Private Cloud) is a logically isolated virtual network in AWS where we can launch AWS resources like EC2, RDS and Load Balancers.

It allows us to control:

- IP Address Range
- Subnets
- Route Tables
- Internet Access
- Security Rules

In my project, we use VPC to securely host production servers and control network communication.

---

# Q2. What is the difference between Default VPC and Custom VPC?

## Answer

### Default VPC

- Created automatically by AWS.
- Comes with public subnets.
- Internet Gateway is already attached.
- Suitable for testing and learning.

### Custom VPC

- Created manually.
- We decide the CIDR range.
- We create our own subnets, route tables and gateways.
- Mostly used in production environments.

---

# Q3. What is a CIDR Block?

## Answer

CIDR (Classless Inter-Domain Routing) defines the IP address range of a VPC or Subnet.

Example:

VPC CIDR:
```

10.0.0.0/16

```

Subnet CIDR:
```

10.0.1.0/24

```

A subnet CIDR must always be within the VPC CIDR range.

---

# Q4. What is a Subnet?

## Answer

A Subnet is a smaller network created inside a VPC.

It helps organize resources based on security and network requirements.

There are two types:

- Public Subnet
- Private Subnet

---

# Q5. What is the difference between Public and Private Subnet?

## Answer

### Public Subnet

- Has a route to the Internet Gateway.
- EC2 instances can access the internet.
- Used for Web Servers, Bastion Hosts and Load Balancers.

### Private Subnet

- Does not have a direct route to the Internet Gateway.
- Used for Application Servers, Databases and Internal Services.
- Internet access (if required) is provided through a NAT Gateway.

---

# Q6. What is an Internet Gateway (IGW)?

## Answer

An Internet Gateway is a VPC component that allows communication between the VPC and the Internet.

To make a subnet public:

- Attach an IGW to the VPC.
- Add a default route (0.0.0.0/0) to the Route Table pointing to the IGW.
- Enable a Public IP on the EC2 instance.

Without these, the EC2 instance cannot access the internet.

---

# Q7. What is a Route Table?

## Answer

A Route Table contains rules that decide where network traffic should go.

Example:

- Local traffic stays inside the VPC.
- Internet traffic goes to the Internet Gateway.
- Private subnet traffic can go to the NAT Gateway.

Every subnet must be associated with a Route Table.

---

# Q8. What is the difference between Public IP and Private IP?

## Answer

### Private IP

- Used for communication within the VPC.
- Does not change during the life of the instance.

### Public IP

- Used for internet communication.
- By default, it changes when the instance is stopped and started.

For production servers requiring a fixed public address, we generally use an Elastic IP.

---

# Q9. What is an Elastic IP?

## Answer

An Elastic IP is a static public IPv4 address provided by AWS.

It remains the same even if the instance is stopped and started.

It is commonly used for:

- Bastion Hosts
- NAT Gateways
- Public-facing servers requiring a fixed IP

---

# Q10. What is a NAT Gateway?

## Answer

A NAT Gateway allows EC2 instances in a Private Subnet to access the internet without exposing them to inbound internet traffic.

Example:

A private EC2 can:

- Download software updates.
- Install packages.
- Access AWS services over the internet.

Users from the internet cannot directly connect to that EC2 instance.

---

# Q11. What is a Security Group?

## Answer

A Security Group acts as a virtual firewall at the EC2 instance level.

Features:

- Stateful
- Supports Allow rules only
- Controls inbound and outbound traffic

Example:

Allow:

- SSH (22)
- HTTP (80)
- HTTPS (443)

---

# Q12. What is a Network ACL (NACL)?

## Answer

A Network ACL is a firewall that works at the subnet level.

Features:

- Stateless
- Supports both Allow and Deny rules
- Controls inbound and outbound traffic

It provides an additional layer of network security.

---

# Q13. What is a Bastion Host?

## Answer

A Bastion Host is an EC2 instance deployed in a Public Subnet.

Administrators first connect to the Bastion Host using SSH.

From the Bastion Host, they securely access EC2 instances located in Private Subnets.

This avoids exposing private servers directly to the internet.

---

# Q14. What VPC activities do you perform in your project?

## Answer

In my project, I regularly perform:

- Verify Security Group rules
- Check Network ACL rules
- Verify Route Tables
- Troubleshoot connectivity issues
- Verify Internet Gateway attachment
- Verify NAT Gateway configuration
- Coordinate with the Network and Cloud Teams
- Update Jira tickets and RCA for network-related incidents

---

# Q15. A web server is not reachable from the internet. How will you troubleshoot?

## Answer

First, I verify whether the EC2 instance is running and all status checks are passed.

Then I check whether the instance has a Public IP or Elastic IP.

Next, I verify the Security Group inbound rules for HTTP (80), HTTPS (443) or SSH (22), depending on the service.

Then I verify the Route Table and ensure that the Public Subnet has a default route (0.0.0.0/0) pointing to the Internet Gateway.

I also verify that the Internet Gateway is attached to the VPC.

If required, I check the Network ACL to ensure it is not blocking the traffic.

Finally, I test the connectivity, confirm the application is working and update the Jira ticket with the root cause.


# 🌐 VPC Interview Questions - Part 02 (Advanced)

---

# Q16. What is VPC Peering?

## Answer

VPC Peering allows two VPCs to communicate with each other using private IP addresses.

Requirements:

- Both VPCs must have non-overlapping CIDR blocks.
- Routes must be added in both Route Tables.

VPC Peering does not support transitive routing.

---

# Q17. What is Transit Gateway?

## Answer

Transit Gateway is a central hub used to connect multiple VPCs and on-premises networks.

Instead of creating multiple VPC Peering connections, all VPCs connect to the Transit Gateway.

It simplifies network management and is commonly used in large production environments.

---

# Q18. What is the difference between VPC Peering and Transit Gateway?

## Answer

### VPC Peering

- Connects two VPCs directly.
- Suitable for a small number of VPCs.
- Does not support transitive routing.

### Transit Gateway

- Connects multiple VPCs through a central hub.
- Easier to manage in large environments.
- Supports transitive routing.

---

# Q19. What is a VPC Endpoint?

## Answer

A VPC Endpoint allows private communication between a VPC and AWS services without using the Internet Gateway, NAT Gateway or public internet.

This improves security because traffic remains within the AWS network.

---

# Q20. What are the types of VPC Endpoints?

## Answer

There are two commonly used types:

### Gateway Endpoint

Used for:

- Amazon S3
- DynamoDB

---

### Interface Endpoint

Used for most other AWS services.

It creates Elastic Network Interfaces (ENIs) inside your VPC.

---

# Q21. What is Site-to-Site VPN?

## Answer

Site-to-Site VPN securely connects an on-premises data center to an AWS VPC over the public internet using encrypted tunnels.

It is commonly used in hybrid cloud environments.

---

# Q22. What is AWS Direct Connect?

## Answer

AWS Direct Connect provides a dedicated private network connection between an on-premises data center and AWS.

Compared to Site-to-Site VPN, it offers:

- Lower latency
- More consistent performance
- Higher bandwidth
- Better reliability

It is commonly used by enterprises with high network traffic.

---

# Q23. What are VPC Flow Logs?

## Answer

VPC Flow Logs capture information about network traffic entering and leaving network interfaces.

They help in:

- Troubleshooting connectivity issues
- Identifying blocked traffic
- Security investigations
- Auditing network activity

Flow Logs can be sent to CloudWatch Logs or Amazon S3.

---

# Q24. What are DNS Resolution and DNS Hostnames?

## Answer

### DNS Resolution

Allows instances inside the VPC to resolve domain names into IP addresses.

### DNS Hostnames

Assigns DNS hostnames to EC2 instances.

For public instances, enabling DNS Hostnames allows AWS to provide a public DNS name.

---

# Q25. My EC2 instance cannot access the internet. How will you troubleshoot?

## Answer

First I verify whether the EC2 instance has a Public IP or Elastic IP.

Then I verify that the subnet Route Table has a default route (0.0.0.0/0) pointing to the Internet Gateway.

Next I check whether the Internet Gateway is attached to the VPC.

Then I verify the Security Group outbound rules.

I also verify the Network ACL rules.

If the EC2 is in a Private Subnet, I verify that the Route Table points to a NAT Gateway and that the NAT Gateway is available.

Finally, I test the connectivity and update the Jira ticket.

---

# Q26. What is the difference between Security Group and Network ACL?

## Answer

| Security Group | Network ACL |
|---------------|-------------|
| Works at Instance Level | Works at Subnet Level |
| Stateful | Stateless |
| Supports Allow rules only | Supports Allow and Deny rules |
| Applied to EC2 Instances | Applied to Subnets |

Security Groups are the primary firewall, while NACL provides an additional security layer.

---

# Q27. What is the difference between Internet Gateway and NAT Gateway?

## Answer

### Internet Gateway

- Used by Public Subnets.
- Allows inbound and outbound internet communication.

### NAT Gateway

- Used by Private Subnets.
- Allows only outbound internet access.
- Blocks inbound connections initiated from the internet.

---

# Q28. Explain one VPC issue you handled.

## Answer

A user reported that the application hosted on an EC2 instance was not accessible.

First I verified that the EC2 instance was running.

Then I checked the Security Group and found that port 443 was not allowed.

After adding the required inbound rule (after approval), I tested the application again.

The application became accessible successfully.

Finally, I updated the Jira ticket and documented the RCA.

---

# Q29. What VPC activities do you perform regularly?

## Answer

In my project, I regularly perform:

- Verify Security Groups
- Verify Network ACLs
- Check Route Tables
- Verify Internet Gateway
- Verify NAT Gateway
- Troubleshoot connectivity issues
- Verify VPC Flow Logs when required
- Coordinate with the Network Team
- Update Jira tickets and RCA

---

# Q30. What are the most common VPC issues you handle?

## Answer

Some common VPC issues are:

- EC2 not reachable
- SSH connection failure
- Website not accessible
- Security Group misconfiguration
- Network ACL blocking traffic
- Route Table misconfiguration
- NAT Gateway issue
- Internet connectivity issue
- DNS resolution issue

# Q31. What is the difference between NAT Gateway and NAT Instance?

## Answer

| NAT Gateway | NAT Instance |
|-------------|--------------|
| Fully Managed AWS Service | EC2 Instance configured as NAT |
| High Availability within an AZ | Availability depends on the EC2 instance |
| Automatically scales | Manual scaling required |
| No OS maintenance | OS patching and maintenance required |
| Better performance | Performance depends on instance type |
| AWS manages updates | Customer manages updates |
| More expensive | Lower cost for small workloads |

In modern AWS environments, NAT Gateway is the recommended option because it is fully managed, highly available and requires minimal maintenance.

NAT Instance is generally used only in legacy environments or when there are specific cost or customization requirements.

---

# ⭐ Frequently Asked Cross Questions

### Q1. Can two VPCs with the same CIDR communicate using VPC Peering?

**Answer:**
No. VPC Peering requires non-overlapping CIDR ranges.

---

### Q2. Can a Private EC2 instance access the internet directly?

**Answer:**
No. It requires a NAT Gateway or NAT Instance for outbound internet access.

---

### Q3. Can a Security Group block traffic?

**Answer:**
No. Security Groups support only **Allow** rules. To explicitly block traffic, use a Network ACL.

---

### Q4. Which is more secure: Bastion Host or Session Manager?

**Answer:**
AWS Systems Manager Session Manager is generally more secure because it does not require opening SSH (port 22) to the internet and provides centralized access with logging.

---

### Q5. Which service helps identify whether network traffic is being accepted or rejected?

**Answer:**
VPC Flow Logs.