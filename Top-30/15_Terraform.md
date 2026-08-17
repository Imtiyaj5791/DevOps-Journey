# Terraform — Top 30 Interview Questions

## 1. What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool used to create and manage infrastructure using configuration files.

For example, we can create EC2, VPC, Security Groups, S3 and other AWS resources using Terraform.

---

## 2. What is Infrastructure as Code (IaC)?

Infrastructure as Code means creating and managing infrastructure using code instead of manually creating resources from the AWS Console.

**Remember:**

    IaC = Manage Infrastructure Using Code

---

## 3. What are the main Terraform commands?

The main Terraform commands are:

    terraform init
    terraform validate
    terraform plan
    terraform apply
    terraform destroy

**Flow:**

    init → validate → plan → apply → destroy

---

## 4. What happens when you run `terraform init`?

`terraform init` initializes the Terraform working directory.

It downloads the required providers and prepares the directory to work with Terraform.

---

## 5. What is `terraform validate`?

`terraform validate` checks whether the Terraform configuration is syntactically valid.

Command:

    terraform validate

---

## 6. What is `terraform plan`?

`terraform plan` shows what changes Terraform is going to make before actually making those changes.

For example, it can show:

    2 to add
    1 to change
    1 to destroy

It does not normally make the actual infrastructure changes.

---

## 7. What is `terraform apply`?

`terraform apply` applies the required changes and creates, updates or deletes resources based on the Terraform configuration.

Command:

    terraform apply

---

## 8. What is `terraform destroy`?

`terraform destroy` is used to delete the infrastructure managed by the current Terraform configuration/state.

Command:

    terraform destroy

---

## 9. What is a Terraform Provider?

A Provider allows Terraform to communicate with a platform or service such as AWS.

Example:

    provider "aws" {
      region = "ap-south-1"
    }

**Remember:**

    Terraform → Provider → AWS

---

## 10. What is a Terraform Resource?

A resource block defines the infrastructure object that we want Terraform to manage.

Example:

    resource "aws_instance" "web" {
      ami           = "ami-xxxxxxxx"
      instance_type = "t2.micro"
    }

Here:

    aws_instance = Resource Type
    web          = Local Resource Name

---

## 11. What is a Terraform variable?

A variable is used to pass values into our Terraform configuration.

Example:

    variable "instance_type" {
      default = "t2.micro"
    }

We can reuse the variable in our code.

---

## 12. What is the difference between a Variable and a Local Value?

Variables and locals both help us avoid repeating values.

A variable can receive its value from outside the configuration.

A local value is defined inside the Terraform configuration and is mainly used to reuse expressions or values internally.

Example:

    variable "environment" {
      default = "dev"
    }

    locals {
      project_name = "myapp"
    }

**Remember:**

    Variable → Input value
    Local    → Internal reusable value/expression

---

## 13. What is `terraform.tfvars`?

`terraform.tfvars` is commonly used to provide values for Terraform input variables.

Example:

    instance_type = "t3.micro"
    environment   = "prod"

Terraform automatically loads `terraform.tfvars`.

---

## 14. What is a Terraform Output?

Output is used to display or expose useful information after Terraform creates infrastructure.

Example:

    output "instance_public_ip" {
      value = aws_instance.web.public_ip
    }

After `terraform apply`, Terraform can display the EC2 public IP.

---

## 15. What is the Terraform State File?

Terraform state file is the heart of Terraform.

It keeps track of the resources created and managed by Terraform.

When we run Terraform again, Terraform uses the state file to help determine what changes are required.

Default file:

    terraform.tfstate

**Remember:**

    .tf files         → What we want
    terraform.tfstate → What Terraform tracks/knows

---

## 16. Why should we not manually modify `terraform.tfstate`?

We should not normally modify the Terraform state file manually because incorrect changes can cause state inconsistency and infrastructure management problems.

Terraform commands should be used to manage the state.

---

## 17. Why do we use Remote State?

In a team environment, keeping the state file only on one engineer's local machine is not suitable.

We can store the Terraform state remotely so the team can work with shared state.

For AWS environments, Amazon S3 can be used as a remote backend.

**Remember:**

    Local State  → Local Machine
    Remote State → Shared Central Location

---

## 18. What is State Locking?

State locking helps prevent multiple Terraform operations from modifying the same state at the same time.

This helps avoid state corruption or conflicting changes.

**Remember:**

    State Locking = Prevent Concurrent State Changes

---

## 19. What is the difference between `count` and `for_each`?

Both are used to create multiple resources.

`count` identifies resource instances using numeric indexes.

Example:

    count = 3

Resources:

    aws_instance.web[0]
    aws_instance.web[1]
    aws_instance.web[2]

`for_each` identifies resources using keys.

Example:

    for_each = toset(["dev", "test", "prod"])

Resources are identified by keys such as:

    aws_instance.web["dev"]
    aws_instance.web["test"]
    aws_instance.web["prod"]

**Remember:**

    count    → Index
    for_each → Key

---

## 20. You created 5 EC2 instances using `count`. How can you target the 1st and 5th instances for destruction?

Because `count` starts from index 0:

    1st instance → [0]
    5th instance → [4]

Command:

    terraform destroy \
      -target="aws_instance.web[0]" \
      -target="aws_instance.web[4]"

**Important:**

If the configuration still requires all 5 instances, a later normal `terraform apply` can recreate the missing instances.

---

## 21. How would you remove specific resources created using `for_each`?

Suppose we have:

    for_each = toset(["app1", "app2", "app3", "app4", "app5"])

If we no longer require `app1` and `app5`, remove those keys from the configuration:

    for_each = toset(["app2", "app3", "app4"])

Then run:

    terraform plan

Verify that Terraform plans to remove the expected resources.

Then:

    terraform apply

**Remember:**

    Remove Keys → terraform plan → terraform apply

---

## 22. What is `depends_on` in Terraform?

`depends_on` is used when we need to explicitly define a dependency between resources.

Example:

    resource "aws_instance" "app" {
      depends_on = [aws_security_group.app_sg]
    }

It tells Terraform that the required dependency should be handled before the dependent resource.

**Remember:**

    depends_on = Explicit Dependency

---

## 23. What is Terraform Import?

Terraform Import is used to bring an existing resource that was created outside Terraform under Terraform state management.

For example, if an existing database was created manually and we now want Terraform to manage it, we can import it.

Typical flow:

1. Write the appropriate resource block.
2. Run `terraform init` if required.
3. Import the existing resource.
4. Run `terraform plan`.
5. Update the configuration until it matches the real resource as required.

Example:

    terraform import aws_db_instance.mydb <db-identifier>

**Remember:**

    Existing Resource → Terraform Import → Terraform State

---

## 24. What are Terraform Workspaces?

Terraform Workspaces allow us to maintain separate state instances for the same Terraform configuration.

For example:

    dev
    test
    prod

Commands:

    terraform workspace list
    terraform workspace new dev
    terraform workspace select dev

**Remember:**

    Same Configuration → Different Workspace State

---

## 25. Someone manually changes a Terraform-managed EC2 instance from the AWS Console. What happens when you run `terraform plan`?

Terraform checks the real infrastructure and compares it with the configuration and state information.

If someone manually changed a Terraform-managed resource, `terraform plan` can detect the difference and show the action required to bring the infrastructure back in line with the configuration.

This is commonly called **configuration drift**.

**Remember:**

    Manual Change → Drift
    terraform plan → Detect Difference

---

## 26. What happens if someone manually deletes an EC2 instance created by Terraform?

Terraform still has information about the managed resource in its state.

When we run:

    terraform plan

Terraform refreshes/checks the actual infrastructure and detects that the EC2 instance is missing.

If the Terraform configuration still requires that instance, the plan will normally show that the resource needs to be created again.

Then:

    terraform apply

can recreate the required resource.

---

## 27. What is a Terraform Module?

A Terraform Module is a reusable collection of Terraform configuration files.

Instead of writing the same infrastructure code again and again, we can create a module and reuse it.

Example:

    module "ec2" {
      source = "./modules/ec2"
    }

**Remember:**

    Module = Reusable Terraform Code

---

## 28. Why do we use Terraform Modules?

We use modules to:

- Reuse code
- Avoid duplicate code
- Keep Terraform configuration organized
- Standardize infrastructure
- Make infrastructure easier to maintain

Example:

    EC2 Module
        ↓
    Dev
    Test
    Prod

The same module can be reused with different input values.

---

## 29. How should AWS credentials be handled when using Terraform?

We should not hard-code AWS access keys and secret keys inside Terraform files.

We can use secure authentication methods such as:

- IAM Role when Terraform runs on AWS
- AWS CLI/profile credentials
- Environment-based or identity-based authentication as appropriate

**Remember:**

    Never hard-code Access Key / Secret Key in Terraform code

---

## 30. How would you troubleshoot a Terraform failure?

First, I will read the Terraform error carefully.

Then I will check:

1. Terraform configuration
2. `terraform validate`
3. Provider configuration
4. Variables and values
5. AWS permissions
6. Resource dependencies
7. Terraform state if relevant
8. Existing AWS resource/configuration

Then I will run:

    terraform plan

and verify the expected changes before applying again.

---

# Quick Revision

    Terraform
    → Infrastructure as Code Tool

    IaC
    → Manage Infrastructure Using Code

    init
    → Initialize Terraform + Download Providers

    validate
    → Validate Configuration

    plan
    → Show Proposed Changes

    apply
    → Apply Changes

    destroy
    → Destroy Managed Infrastructure

    Provider
    → Connect Terraform with AWS/Other Platform

    Resource
    → Infrastructure Object

    Variable
    → Input Value

    Local
    → Internal Reusable Value/Expression

    tfvars
    → Variable Values

    Output
    → Display/Expose Useful Values

    State
    → Track Managed Resources

    Remote State
    → Shared State Location

    State Locking
    → Prevent Concurrent State Changes

    count
    → Numeric Index

    for_each
    → Key

    depends_on
    → Explicit Dependency

    Import
    → Bring Existing Resource into Terraform State Management

    Workspace
    → Separate State for Same Configuration

    Drift
    → Infrastructure Changed Outside Terraform

    Module
    → Reusable Terraform Code

---

# Most Important Interview Questions

1. What is Terraform?
2. What happens when you run `terraform init`?
3. What is `terraform plan`?
4. What is Terraform State?
5. Why do we use Remote State?
6. What is State Locking?
7. Variable vs Local?
8. What is `terraform.tfvars`?
9. What is the difference between `count` and `for_each`?
10. How do you remove specific resources created using `count`?
11. How do you remove specific resources created using `for_each`?
12. What is `depends_on`?
13. What is Terraform Import?
14. What are Terraform Workspaces?
15. What happens if someone manually changes a Terraform-managed resource?
16. What happens if someone manually deletes a Terraform-managed EC2?
17. What is a Terraform Module?
18. Why do we use Modules?
19. How do you securely handle AWS credentials in Terraform?
20. How would you troubleshoot a Terraform failure?
