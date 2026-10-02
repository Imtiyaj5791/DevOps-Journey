# SECTION A: BASICS - 10 Qs

## 1. What is Terraform and why use it over CloudFormation?

Terraform is an IaC tool which is used to create, manage and delete infrastructure on the cloud like AWS, Azure, GCP.
Why use it over CloudFormation?
Because CloudFormation works only on AWS, but Terraform works on all clouds with same language. So we can manage everything from one tool.

## 2. What is Provider, Resource, Data Source?

Provider is a plugin which is used to communicate with cloud like AWS, Azure.
Resource is what we create by Terraform like EC2, S3, VPC.
Data Source is already created resource which we use as reference. Like if VPC is already there, we fetch it by data source to use in our code.

## 3. Explain main.tf, variables.tf, outputs.tf, terraform.tfvars

main.tf -> we have resources code
variables.tf -> is used to declare the variable
terraform.tfvars -> is used to store the variable value
outputs.tf -> is used to display output like IP address after resource created

## 4. What is terraform state file? What if you delete it?

Terraform state file is the heart of Terraform. It stores the information of resources which are created and managed by Terraform. 
So next time when we run terraform apply, it will first check the state file.If we delete it, we will first check if any backup is available. 
If backup is not available and state is local, we need to import the resources again with terraform import. Otherwise Terraform will try to 
create resources again and give "already exists" error. That's why we store state file in S3 remote backend.

## 5. What is terraform init, plan, apply, destroy?

terraform init is used to initialize the directory and install the provider plugins to communicate with cloud like AWS.
terraform plan is like a blueprint, it will show what is going to create, modify or delete.
terraform apply will create, modify or delete the resources which we saw in plan.
terraform destroy will delete all the resources managed by Terraform.

## 6. What is State Locking and why it is needed? How S3 + DynamoDB does it?

State locking is used to lock the state file when multiple users work on same folder, so we don't get conflict error during apply.
Previously we used S3 for backend and DynamoDB for locking. Now Terraform has inbuilt feature, we use S3 as remote backend with 
use_lockfile = true to lock the state file.

## 7. Difference between count and for_each?

Both are used to create multiple resources at a time.

count is used when we want to create resources with index number like app-0, app-1.
for_each is used when we want to create resources with key-value names like app, db.

## 8. What are Terraform Modules? How you create reusable module?

Terraform module is a reusable code so we don't need to write the same infra again and again. For example, if we want to create same 
VPC in dev and prod, we can call the module.
We have 2 types of modules: root and child. Child module is where the actual source code is present, and root module is the caller who 
calls the child module.

## 9. What is variable types - string, list, map, object?

Variable is a reusable value. If we have to change same value at multiple places, we create a variable and just change the variable value.

string - for single text value like "t2.micro"
list - for multiple values like ["a", "b", "c"]
map - for key-value pair like { dev = "t2.micro", prod = "t3.large" }
object - for combination of different types in one variable.

## 10. How to handle secrets in Terraform?

We never hardcode secrets in Terraform code.

1. Environment Variables: We set secret as TF_VAR_ environment variable, like export TF_VAR_db_password="secret". 
Terraform automatically reads it. It's good for local development.

2. AWS SSM Parameter Store / Secrets Manager: This is most common in AWS projects. We store the secret in SSM and fetch it in Terraform 
using a data source.

3. HashiCorp Vault: For enterprise or multi-cloud setup, we use Vault. We fetch secrets using vault_generic_secret data source.

Also, we mark variable as sensitive = true so it doesn't show in logs or console output.

# SECTION B: INTERMEDIATE - 10 Qs

## 11. What is Remote State? How to store state in S3 backend?

By default Terraform stores state file locally as terraform.tfstate.
This is risky in a team because others cannot access it and if it gets deleted we lose infra tracking.To solve this we use Remote State,
where we store the state file remotely in a backend like S3.
 

## 12. What is Workspace? When to use it?

Terraform Workspace allows us to use the same code for multiple environments with separate state files.
By default we are in default workspace. We can create new workspaces like: terraform workspace new dev
When we create workspaces, Terraform creates separate state files for each:

When to use it?
We use it when we have same infrastructure for dev, staging, prod but want isolated state.

## 13. What is terraform import? Have you used it?

Terraform import is used when a resource is manually created in console and we want to bring it under Terraform management without recreating it.

Steps:
1. Create empty resource block:
resource "aws_instance" "my_ec2" {
}
2. Run import command:
terraform import aws_instance.my_ec2 i-0abcd1234efgh5678
This will import the current state into terraform.tfstate.
3. Write configuration:
Then we run terraform plan to see the difference and we add required arguments like ami, instance_type, subnet_id, tags to match the real infrastructure.


## 14. What is taint / terraform state replace?

This is used when a resource is degraded or corrupted and we want to force recreate it.
In older versions we used:
terraform taint aws_instance.web
It would mark the resource as tainted in the statefile, so on next terraform apply it would be destroyed and recreated.
But taint is deprecated now. From Terraform v0.15.2+, we use: terraform apply -replace="aws_instance.web"

## 15. What is lifecycle block - create_before_destroy, prevent_destroy?

Lifecycle block controls how Terraform creates, updates and destroys a resource.

1. create_before_destroy = true
Normally Terraform destroys old first then creates new. With this, it creates new first then destroys old.
Use case: Zero downtime. Like when updating Launch Template or EC2.

2. prevent_destroy = true

It prevents accidental deletion. If someone tries to destroy, Terraform will give error.
Use case: For critical resources like S3 bucket with statefile, RDS, Production DB.

## 16. What is provisioner? Why we should avoid it?

Provisioners are used to execute scripts or actions on local or remote machine after resource is created.
Types:

1. file provisioner - to copy file from local to remote EC2
2. local-exec - runs command on local machine where Terraform is running
3. remote-exec - runs command on remote EC2 via SSH, like installing nginx

## 17. Terraform vs Ansible - when to use what?

Terraform is for Infrastructure Provisioning and Ansible is for Configuration Management.

We use Terraform first to provision the EC2 server, and then we use Ansible to configure that server, like installing packages and deploying app.

In modern setup, we combine both: Terraform + Ansible, or Terraform + Packer + User Data.


## 18. How to do version locking of provider and terraform?

We do version locking in terraform block to avoid breaking changes in production.

1. Terraform Version Locking:

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

2. Provider Version Locking:

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # means >=5.0 and <6.0
    }
  }
}


## 19. How you manage 3 environments - dev, staging, prod - in Terraform?

I use a module-based, folder-per-environment approach. I don't use workspaces for this.
I have one reusable module, and three environment folders - dev, staging, prod. Each environment has its own backend and state file for isolation.


## 20. What is drift and how to handle it?

Drift is when our actual infrastructure on AWS is different from our desired infrastructure defined in Terraform code. 
It happens when someone makes manual changes from the AWS console.

For example, in Terraform code we have t2.micro, but someone manually changed it to t2.medium from console. When we run terraform plan, 
Terraform will detect this mismatch and show drift.

How to handle it:

First, I run terraform plan to identify which resource has drifted.
Then I check with the team if this manual change was intentional.
If it was intentional, I update my Terraform code to match the new state, i.e., change t2.micro to t2.medium in code.
If it was not intentional, I run terraform apply to revert the infrastructure back to the desired state defined in code.

"To prevent drift, we use driftctl in our pipeline to detect drift early, and we restrict manual changes by giving 
read-only IAM access and enforcing changes only via Terraform pipeline."

# SECTION C: ADVANCED + EKS - 5 Qs - MOST IMPORTANT FOR YOU

## 21. How to create EKS cluster with Terraform? Which modules you used?

I used the terraform-aws-modules/eks/aws module to create the EKS cluster.
I also used the terraform-aws-modules/vpc/aws module to create the VPC, and passed its private subnets to the EKS module.

## 22. What is locals in Terraform? Difference between locals and variables?

In Terraform, locals is used to define local values or expressions inside the code itself.
Its value cannot be changed from outside, like from tfvars or command line.

technically everything can be done with variables, but there are main technical reasons for locals:

1. Variables cannot reference other variables, It will throw an error. In locals you can do this. So locals is needed to combine variables.

 You cannot write
 
variable "bucket_name" {
  default = "prod-${var.env}-bucket" // YE ERROR DEGA
}
 
locals {
  bucket_name = "prod-${var.env}-bucket" // YE CHALEGA
}
 
## 23. Tell me about your EKS + Terraform folder structure?

I follow an environment-based structure. I have a modules/ folder which contains reusable code for VPC and EKS.
Then I have an envs/ folder with separate folders for dev and prod.
Each env folder has its own main.tf which calls the VPC and EKS modules, plus a .tfvars file for env-specific values.
This keeps our code DRY and environment isolated.

modules/vpc/
modules/eks/
envs/dev/main.tf
envs/prod/main.tf

## 24. How to do zero-downtime infra update with Terraform?

"To achieve zero-downtime infra updates with Terraform, we use the
 lifecycle { 
 create_before_destroy = true
 } block. 
This ensures Terraform creates the new resource before destroying the old one. 
For example, in case of ASG or Launch Template changes, we combine it with AWS instance_refresh and ALB, 
so new instances are up and healthy before the old ones are terminated, resulting in zero downtime at the infra level."

## 25. How you handle error when terraform apply fails in middle?

"When terraform apply fails in the middle, first I check the error logs. 
Then I run terraform state list to see what resources are already tracked in state and compare it with AWS console to find any drift.
If a resource is created in AWS but not in state due to a state save failure, I use terraform import to bring it into state.
Otherwise I fix the root cause in code and re-run terraform apply. Terraform is idempotent, so it will only create the pending resources."
