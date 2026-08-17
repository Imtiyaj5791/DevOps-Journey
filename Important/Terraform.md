# Terraform Interview Questions & Answers

> **Level:** Working Knowledge
> **Cloud:** AWS
> **Focus:** Easy to Medium Interview Questions

---

# What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool which is used to provision and manage infrastructure on cloud platforms like AWS, Azure, and GCP.

The main advantage of Terraform is reusable code. Once we write the code, we can use the same code again to create the same infrastructure whenever required.

It saves time, reduces manual work, and minimizes human errors.

---

# Why do we use Terraform when we can create resources from the AWS Console?

Yes, we can create resources from the AWS Console, but if we create infrastructure manually, it takes more time and there are more chances of human errors.

With Terraform, we write the code only once. After that, we can reuse the same code to create the same infrastructure whenever required.

It saves time, reduces manual work, and minimizes human errors.

---

# If Terraform is so good, why do people still use the AWS Console?

We use Terraform for automation and reusable infrastructure.

We use the AWS Console for:

- Quick changes
- Learning
- Testing
- Troubleshooting

Both have their own use cases.

---

# Provider

## What is a Provider in Terraform?

A provider is a plugin that helps Terraform connect to cloud platforms like AWS, Azure, or GCP so that it can create and manage resources.

### Example

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## Can Terraform work without a provider?

No. Terraform cannot work without a provider because the provider is required to communicate with the cloud platform and create or manage resources.

---

## How does Terraform know which provider to use?

We define the provider in our Terraform code.

For example, if I want to create resources in AWS, I use the AWS provider block.

When I run **terraform init**, Terraform automatically downloads the AWS provider and uses it to communicate with AWS.

### Command

```bash
terraform init
```

---

# Terraform Init

## Why do we run terraform init?

Terraform init is used to download the required provider.

After downloading the provider, Terraform uses it to communicate with the cloud platform like AWS.

### Command

```bash
terraform init
```

---

## Do we run terraform init every time?

No.

We run terraform init the first time to download the required provider.

If we create a new project or change the provider, we run it again.

---

# Terraform Workflow

## terraform init

Download the required provider to communicate with the cloud platform.

```bash
terraform init
```

---

## terraform plan

Terraform plan is like a blueprint.

It shows what resources Terraform is going to create, modify, or destroy before making any changes.

### Command

```bash
terraform plan
```

Save the execution plan.

```bash
terraform plan -out=tfplan
```

---

## terraform apply

Terraform apply creates the resources defined in the Terraform code.

### Command

```bash
terraform apply
```

Apply saved plan.

```bash
terraform apply tfplan
```

Skip confirmation.

```bash
terraform apply --auto-approve
```

---

## Can we run terraform apply directly without running terraform plan?

Yes, we can run terraform apply directly.

Terraform automatically checks the changes before applying them.

If we use **--auto-approve**, it skips the confirmation only.

But in production, I prefer to run terraform plan first because it shows exactly what is going to be created, modified, or destroyed.

---

# Terraform State File

## What is Terraform State File or terraform.tfstate?

Terraform state file is the heart of Terraform. It stores all resources created and managed by Terraform. When we run Terraform again, it uses the state file to check what changes are required.

### Useful Commands

```bash
terraform state list
```

Show a specific resource.

```bash
terraform state show aws_instance.web
```

Show complete state.

```bash
terraform show
```

---

## What will happen if you delete the terraform.tfstate file?

If the terraform.tfstate file is deleted, first I will check if there is any backup and restore it.

If there is no backup, Terraform loses the information about the existing infrastructure.

The next time we run terraform apply, Terraform may try to create the resources again because it cannot track the existing resources.

---

# Terraform Drift

## What is Drift in Terraform?

Terraform Drift means difference between desired code and current infrastructure.

For example,

In the Terraform code instance type is **t2.micro**, but someone changed it to **t3.micro** from the AWS Console.

When we run terraform plan, it shows the changes.

### Command

```bash
terraform plan
```

---

## How can you fix Terraform Drift?

We have two options.

First, we can update the Terraform code according to the new infrastructure.

Second, we can revert the manual changes from the AWS Console so the infrastructure matches the Terraform code again.

---

# Terraform Validate

## What is terraform validate?

Terraform validate is used to validate the Terraform code.

If there is any error in the code, it shows the error before creating the infrastructure.

### Command

```bash
terraform validate
```

---

# Terraform fmt

## What is terraform fmt?

Terraform fmt is used to format the Terraform code.

It automatically arranges the code in a proper and readable format.

### Command

```bash
terraform fmt
```

Format all Terraform files.

```bash
terraform fmt -recursive
```

---

# Terraform Destroy

## What is terraform destroy?

Terraform destroy is used to destroy all the resources created by Terraform.

It uses the Terraform state file to identify the resources and destroy them.

### Command

```bash
terraform destroy
```

Skip confirmation.

```bash
terraform destroy --auto-approve
```

---

## Can we destroy only one Terraform resource instead of all resources?

Yes, we can destroy only one resource instead of all resources.

We use the target option and specify the resource name.

### Command

```bash
terraform destroy -target=aws_instance.web
```
# Variables

## What are Variables in Terraform?

Terraform variables are used to make the code reusable.

They help us avoid hardcoding values.

For example,

If I have a 1000-line Terraform file and I use the same value many times, I don't need to change it everywhere.

I just update the variable value once, and it is updated everywhere it is used.

### Variable Example

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

Using Variable

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type
}
```

---

# terraform.tfvars

## What is terraform.tfvars?

Terraform.tfvars is used to store the values of the variables.

This helps us avoid hardcoding values in the Terraform code.

### Example

```hcl
instance_type = "t2.micro"
environment   = "dev"
```

---

## What is the difference between variables.tf and terraform.tfvars?

**variables.tf**

variables.tf is used to define the variables.

Example

```hcl
variable "instance_type" {}
```

---

**terraform.tfvars**

terraform.tfvars is used to store the values of those variables.

Example

```hcl
instance_type = "t2.micro"
```

---

## Can we define variable values without using terraform.tfvars?

Yes, we can define variable values without using terraform.tfvars.

We can pass the variable values while running the Terraform command.

### Command

```bash
terraform apply -var="instance_type=t2.micro"
```

or

```bash
terraform plan -var="instance_type=t2.micro"
```

Using another variable file

```bash
terraform apply -var-file="dev.tfvars"
```

---

# Output

## What is Output in Terraform?

Output is a block where we define the output values.

For example,

After Terraform creates an EC2 instance, it can display the public IP on the terminal.

So, we don't need to log in to the AWS Console to check the public IP.

### Example

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### Command

Show all outputs

```bash
terraform output
```

Show specific output

```bash
terraform output public_ip
```

---

# Locals

## What are Locals in Terraform?

Locals are similar to variables, but they are defined in the local block.

Local values are fixed inside the code, and we cannot change them while running terraform apply.

### Example

```hcl
locals {
  environment = "dev"
}
```

Using Local

```hcl
tags = {
  Environment = local.environment
}
```

---

## Variable vs Locals

### Variables

Variables can be changed at runtime.

Example

```bash
terraform apply -var="instance_type=t3.micro"
```

---

### Locals

Locals are fixed values inside the Terraform code and cannot be changed at runtime.

---

# Module

## What is Module?

A module is a reusable Terraform code.

Instead of writing the same code again and again, we can use a module to create the infrastructure.

We can use our own module or download a module from the Terraform Registry.

### Example

```hcl
module "ec2" {
  source = "./modules/ec2"
}
```

Terraform Registry

https://registry.terraform.io/

Initialize module

```bash
terraform init
```

---

## Advantages of Module

- Reusable code
- Avoid duplicate code
- Easy to maintain
- Easy to manage
- Standardized infrastructure

# Workspace

## What is Workspace?

Terraform Workspace is used to deploy the same infrastructure in different environments like Development, Testing, and Production.

Each workspace maintains its own Terraform state file.

### Workspace Commands

List all workspaces

```bash
terraform workspace list
```

Show current workspace

```bash
terraform workspace show
```

Create a new workspace

```bash
terraform workspace new dev
```

Switch workspace

```bash
terraform workspace select dev
```

Delete workspace

```bash
terraform workspace delete dev
```

---

# Terraform Import

## What is Terraform Import?

Terraform Import is used when a resource is already created manually in AWS, and we want Terraform to manage that resource.

Instead of creating a new resource, we import the existing resource into Terraform.

### Step 1

Write the resource block.

```hcl
resource "aws_instance" "web" {

}
```

### Step 2

Import the existing resource.

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

### Step 3

Verify everything.

```bash
terraform plan
```

---

## After importing the resource, is the work completed?

No.

Import is not enough.

After importing the resource, we also need to write the Terraform configuration in the `.tf` file.

Then we run terraform plan to verify everything is in sync.

---

# Quick Commands Revision

## Initialize

```bash
terraform init
```

---

## Validate Code

```bash
terraform validate
```

---

## Format Code

```bash
terraform fmt
```

---

## Create Execution Plan

```bash
terraform plan
```

Save Plan

```bash
terraform plan -out=tfplan
```

---

## Apply Changes

```bash
terraform apply
```

Apply Saved Plan

```bash
terraform apply tfplan
```

Skip Confirmation

```bash
terraform apply --auto-approve
```

---

## Destroy Resources

```bash
terraform destroy
```

Destroy Specific Resource

```bash
terraform destroy -target=aws_instance.web
```

---

## State Commands

List Resources

```bash
terraform state list
```

Show Resource

```bash
terraform state show aws_instance.web
```

Show Current State

```bash
terraform show
```

---

## Output Commands

Show All Outputs

```bash
terraform output
```

Show Specific Output

```bash
terraform output public_ip
```

---

## Workspace Commands

```bash
terraform workspace list
terraform workspace show
terraform workspace new dev
terraform workspace select dev
terraform workspace delete dev
```

---

## Variable Commands

Using Command Line Variable

```bash
terraform apply -var="instance_type=t2.micro"
```

Using tfvars File

```bash
terraform apply -var-file="dev.tfvars"
```

---

## Import Command

```bash
terraform import aws_instance.web i-0123456789abcdef0
```

---

# Most Important Interview Questions ⭐⭐⭐⭐⭐

- What is Terraform?
- Why Terraform instead of AWS Console?
- What is Provider?
- terraform init
- terraform plan
- terraform apply
- terraform validate
- terraform fmt
- terraform destroy
- Terraform State File
- Terraform Drift
- Variables
- terraform.tfvars
- Variable vs Local
- Output
- Module
- Workspace
- Terraform Import

---

# Self Lab Statement (Interview)

> I have working knowledge of Terraform and I am doing self-lab on my laptop.
>
> I have created AWS resources like EC2, Security Groups and VPC resources using Terraform.
>
> I understand Terraform workflow, Provider, Variables, State File, Drift, Output, Module, Workspace and Import.

---

# Interview Tips

- Always run `terraform plan` before `terraform apply` in production.
- Keep the `terraform.tfstate` file safe because Terraform tracks infrastructure using it.
- Avoid manual changes from the AWS Console to prevent Terraform Drift.
- Reuse variables and modules instead of writing duplicate code.
- Practice Import and Workspace commands because they are common interview questions.

---

# End of Terraform Interview Notes

**Level Covered**

- ✅ Beginner
- ✅ Easy Interview
- ✅ Medium Interview
- ✅ Working Knowledge
- ✅ Self Lab Ready
---
