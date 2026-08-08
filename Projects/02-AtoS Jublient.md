<h1 align="center"><span style="color:red">🚀 A to S Jublient Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 🔐 Private VPC Access

## ❓ Our server is in a private VPC. I want to access it, but I don't want to use an Internet Gateway or Bastion Host. How will you access it?

If the server is in a private subnet and we don't want to use an Internet Gateway or Bastion Host, then we can use **AWS Systems Manager (SSM) Session Manager** to connect to the server.

Another option is **EC2 Instance Connect Endpoint**.

If it is a corporate environment, we can also access the private server through a **Site-to-Site VPN** or **AWS Direct Connect**.

---

# 💾 Amazon EBS

## ❓ What is the difference between gp2 and gp3?

Both gp2 and gp3 are **General Purpose SSD** volumes.

gp3 is more flexible and cost-effective than gp2.

In gp2, the performance depends on the volume size (**3 IOPS per GB**).

In gp3, we get **3000 IOPS by default** and can increase **IOPS** and **Throughput** independently without increasing the volume size.

That's why many organizations migrate from gp2 to gp3.

---

## ❓ Can we increase the volume size in gp2?

Yes, we can increase the volume size in gp2.

---

# 🖥️ EC2 Health Checks

## ❓ What is 3/3 Status Check in AWS?

- **System Status Check** → Checks the AWS infrastructure, such as host hardware, power, or network issues.

- **Instance Status Check** → Checks the operating system inside the EC2 instance, such as OS boot issues or network configuration problems.

- **EBS Status Check** → Checks whether the attached EBS volume is healthy and accessible.

---

# 🪣 Mount S3 to EC2

## ❓ How to mount S3 to EC2?

First, I will create an IAM Role with the required S3 permissions and attach it to the EC2 instance.

Then I will install the **s3fs-fuse** package.

After that, I will create a mount point, for example:

```bash
/mnt/s3-bucket
```

Then I will mount the S3 bucket using **s3fs**.

I don't remember the exact mount command.

Finally, if I want a permanent mount, I will add the entry to **/etc/fstab** and verify it using:

```bash
df -h
```

---

# 🌐 VPC Networking

## ❓ VPC Peering vs Transit Gateway

Both VPC Peering and Transit Gateway are used for private communication between multiple VPCs.

VPC Peering is suitable for connecting a small number of VPCs.

If we have many VPCs, such as **10–20**, we use **Transit Gateway** because it acts as a centralized hub and is much easier to manage than creating multiple peering connections.

---

## ❓ Can VPC Peering connect VPCs with overlapping CIDR?

No, we cannot create VPC Peering between VPCs with overlapping CIDR ranges.

Both VPCs must have different CIDR blocks; otherwise, AWS will not allow the peering connection because it creates routing conflicts.

---

## ❓ If both VPCs have the same CIDR, how will you connect them?

VPC Peering is not supported with overlapping CIDRs.

In that case, we first need to redesign the network and assign a different CIDR block to one of the VPCs.

After that, we can create the peering connection.

---

# 🛡️ Security

## ❓ Difference between Security Group, NACL, Internet Gateway, and NAT Gateway

Security Group and NACL both act as firewalls.

A **Security Group** works at the **Instance Level**, whereas a **Network ACL** works at the **Subnet Level**.

Security Groups support only **Allow Rules**, while NACLs support both **Allow** and **Deny Rules**.

Security Groups are **Stateful**, whereas NACLs are **Stateless**.

An **Internet Gateway** provides internet connectivity to resources in a public subnet.

A **NAT Gateway** is used to provide outbound internet access for EC2 instances in a private subnet without allowing inbound connections from the internet.

---

# 🐧 Linux Troubleshooting

## ❓ System is slow because disk usage is 100%. What will you perform on the OS side without moving to the AWS side?

First, I will check which filesystem is full using:

```bash
df -h
```

Then I will identify which directory is consuming more space using:

```bash
du -sh
```

or

```bash
du -sh /*
```

If the space is occupied by logs, I will check whether old logs can be archived or deleted as per the company policy.

If temporary files are consuming space, I will clean them.

If any application or process is generating large files unexpectedly, I will coordinate with the application team.

After freeing up the required space, I will verify that disk usage has come down and check whether the server performance is back to normal.

---
