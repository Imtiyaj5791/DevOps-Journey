# AWS Identity and Access Management (IAM)

## Overview

AWS Identity and Access Management (IAM) is a global AWS service that enables you to securely manage access to AWS resources. It helps control **who can access AWS resources** and **what actions they are allowed to perform**.

IAM follows the **Principle of Least Privilege**, meaning users should receive only the permissions required to perform their job.

> **Note:** IAM is a Global Service and is not associated with any specific AWS Region.

---

# Why IAM?

Before IAM, everyone had to use the AWS Root Account, which is not secure for daily operations.

IAM solves this problem by allowing administrators to create separate identities with limited permissions.

### Benefits of IAM

- Secure access management
- Fine-grained permissions
- Centralized user management
- Multi-Factor Authentication (MFA)
- Temporary access using IAM Roles
- Improved security and compliance

---

# Authentication vs Authorization

| Authentication | Authorization |
|---------------|--------------|
| Verifies the identity of a user. | Determines what the authenticated user can access. |
| Username + Password / MFA | IAM Policies |
| Happens first | Happens after authentication |

### Example

Authentication:

- Login using username and password.

Authorization:

- Permission to Start EC2.
- Permission to Stop EC2.
- Permission to Access S3.

---

# Root User vs IAM User

| Root User | IAM User |
|-----------|----------|
| Created when AWS account is created | Created by Root User or Administrator |
| Full access to AWS Account | Limited permissions |
| Cannot be restricted | Permissions controlled using IAM Policies |
| Should not be used daily | Recommended for daily activities |

### Best Practice

- Enable MFA for Root User.
- Do not use Root User for daily tasks.

---

# IAM Components

## IAM User

An IAM User represents an individual person or application that needs access to AWS resources.

Examples:

- Developer
- System Administrator
- DevOps Engineer

Example:

```
Developer1
```

---

## IAM Group

A Group is a collection of IAM Users.

Instead of assigning permissions individually, permissions are assigned to the Group.

Example:

```
Developers
```

Members:

- Developer1
- Developer2
- Developer3

---

## IAM Policy

A Policy is a JSON document that defines permissions.

Policies specify:

- Allow
- Deny
- Actions
- Resources

Policies are attached to:

- Users
- Groups
- Roles

---

# Types of IAM Policies

## AWS Managed Policy

- Created and maintained by AWS.
- Ready to use.
- Automatically updated by AWS.

Example:

- AmazonEC2ReadOnlyAccess
- AmazonS3ReadOnlyAccess

---

## Customer Managed Policy

- Created and managed by customers.
- Reusable.
- Can be attached to multiple Users, Groups, or Roles.

Example:

```
EC2_Custom
```

Permissions:

- Start Instance
- Stop Instance

---

## Inline Policy

- Attached directly to a single User, Group, or Role.
- Cannot be reused.
- Deleted automatically when the identity is deleted.

Example:

```
RebootInlinePolicy
```

---

# IAM Role

An IAM Role is an AWS identity that provides temporary permissions without using Access Keys.

Roles are mainly used by AWS Services.

Examples:

- EC2
- Lambda
- ECS

> **Note:** IAM Role hands-on will be covered in the EC2 chapter.

---

# Multi-Factor Authentication (MFA)

MFA provides an additional layer of security.

Users must provide:

- Username
- Password
- Verification Code

Benefits:

- Protects against password theft.
- Improves account security.
- Recommended for Root User and IAM Users.

---

# Effective Permissions

AWS combines all Allow permissions attached through:

- User
- Group
- Role

This is called the **Union of Permissions**.

However,

**Explicit Deny always overrides Allow.**

Example:

```
User Policy:
EC2 Full Access

Group Policy:
EC2 ReadOnly

Final Permission:
EC2 Full Access
```

If an Explicit Deny exists:

```
Final Result:
Access Denied
```

---

# Best Practices

- Never use Root User for daily work.
- Enable MFA for Root User.
- Follow the Principle of Least Privilege.
- Prefer Groups instead of assigning permissions individually.
- Use IAM Roles instead of Access Keys whenever possible.
- Rotate credentials regularly.
- Review IAM permissions periodically.

---

# Hands-on Performed

### 1. Created IAM User

```
developer1
```

---

### 2. Created IAM Group

```
Developers
```

---

### 3. Attached AWS Managed Policy

```
AmazonEC2ReadOnlyAccess
```

---

### 4. Created Customer Managed Policy

```
EC2_Custom
```

Permissions:

- Start Instance
- Stop Instance

---

### 5. Attached Customer Managed Policy to Developers Group

Developer1 inherited permissions through the Developers group.

---

### 6. Created Inline Policy

```
RebootInlinePolicy
```

Permission:

- Reboot EC2 Instance

---

### 7. Permission Testing

| Action | Result |
|---------|--------|
| View EC2 | ✅ Allowed |
| Start EC2 | ✅ Allowed |
| Stop EC2 | ✅ Allowed |
| Reboot EC2 | ✅ Allowed |
| Terminate EC2 | ❌ Access Denied |

---

# Interview Questions

### What is IAM?

IAM is a Global AWS service used to securely manage access to AWS resources.

---

### Difference between Authentication and Authorization?

Authentication verifies identity.

Authorization determines permissions.

---

### Difference between IAM User and IAM Role?

IAM User has permanent credentials.

IAM Role provides temporary credentials and is mainly used by AWS services.

---

### Difference between AWS Managed Policy and Customer Managed Policy?

AWS Managed Policies are maintained by AWS.

Customer Managed Policies are created and maintained by customers.

---

### What is an Inline Policy?

An Inline Policy is attached to a single IAM identity and cannot be reused.

---

### What is the Principle of Least Privilege?

Grant only the minimum permissions required to perform a task.

---

### What is Explicit Deny?

Explicit Deny always overrides Allow permissions.

---

# Conclusion

AWS IAM is the foundation of AWS security. It enables secure access management using Users, Groups, Roles, Policies, and MFA while following the Principle of Least Privilege. Understanding IAM is essential before working with AWS services like EC2, S3, Lambda, and other cloud resources.