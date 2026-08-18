# Terraform Notes — Part 1: Basics & Providers

## 1. What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool used to create and manage infrastructure using `.tf` configuration files.

```text
Terraform Code → Provider → Cloud API → Resources
```

---

## 2. Basic Terraform Workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

To delete managed resources:

```bash
terraform destroy
```

### Commands

```text
terraform init      → Initialize project, provider and backend
terraform fmt       → Format Terraform code
terraform validate  → Validate configuration
terraform plan      → Preview infrastructure changes
terraform apply     → Apply changes
terraform destroy   → Destroy managed resources
```

---

## 3. Terraform Provider

Provider allows Terraform to communicate with cloud platforms like AWS, Azure and GCP.

### AWS Provider

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

After adding/changing providers:

```bash
terraform init
```

---

## 4. Multiple Cloud Providers

Terraform can manage multiple cloud providers from the same project.

Example AWS + Azure:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "azurerm" {
  features {}
}
```

---

## 5. Provider Alias

Alias is used when we need **multiple configurations of the same provider**, such as multiple AWS regions.

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}
```

Default provider:

```text
aws → Mumbai
```

Aliased provider:

```text
aws.singapore → Singapore
```

To create a resource in Singapore:

```hcl
resource "aws_instance" "singapore_ec2" {
  provider      = aws.singapore
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

> AMI IDs are region-specific.

---

## 6. Terraform Resource

Example EC2 resource:

```hcl
resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "App-Server"
  }
}
```

Resource address:

```text
aws_instance.app
```

Format:

```text
resource_type.resource_name
```

---

## 7. Common Terraform Files

```text
provider.tf        → Provider configuration
main.tf            → Resources
variables.tf       → Variable declarations
terraform.tfvars   → Variable values
outputs.tf         → Outputs
backend.tf         → Backend configuration
```

Terraform reads all `.tf` files in the same working directory as one configuration.

---

## 8. Important Generated Files

After `terraform init`:

```text
.terraform/
```

contains initialized Terraform/provider data.

```text
.terraform.lock.hcl
```

records provider dependency selections and should normally be committed to Git.

---

## Quick Revision

```text
Terraform = Infrastructure as Code

init      → Initialize
fmt       → Format
validate  → Validate
plan      → Preview
apply     → Apply
destroy   → Delete

Provider  → Terraform communicates with cloud/API
Alias     → Same provider with multiple configurations
Resource  → Infrastructure managed by Terraform
```

# Terraform Notes — Part 2: Variables, tfvars, Locals & Outputs

## 1. Terraform Variables

Variables are used to avoid hardcoding values in Terraform code.

`variables.tf`:

```hcl
variable "instance_type" {
  default = "t3.micro"
}
```

Use in resource:

```hcl
resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type
}
```

Reference:

```text
var.instance_type
```

---

## 2. terraform.tfvars

`terraform.tfvars` is used to provide values to variables.

`variables.tf`:

```hcl
variable "instance_type" {}
```

`terraform.tfvars`:

```hcl
instance_type = "t3.micro"
```

Terraform automatically reads:

```text
terraform.tfvars
```

---

## 3. Variable Types

Common variable types:

```hcl
variable "instance_name" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "enable_monitoring" {
  type = bool
}
```

Other useful types:

```text
list
set
map
object
```

---

## 4. Local Values

Locals are internal reusable values inside Terraform configuration.

```hcl
locals {
  environment = "dev"
}
```

Use:

```hcl
tags = {
  Environment = local.environment
}
```

Reference:

```text
local.environment
```

### Variable vs Local

```text
Variable → Input value can be supplied from outside
Local    → Internal reusable/calculated value
```

---

## 5. Outputs

Outputs are used to display or expose useful Terraform values.

`outputs.tf`:

```hcl
output "instance_id" {
  value = aws_instance.app.id
}
```

After `terraform apply`:

```bash
terraform output
```

Specific output:

```bash
terraform output instance_id
```

---

## 6. Simple Flow

```text
Variable
   ↓
Resource
   ↓
Output
```

Example:

```hcl
variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type
}

output "instance_id" {
  value = aws_instance.app.id
}
```

---

## Quick Revision

```text
Variable         → Input
terraform.tfvars → Variable values
Local            → Internal reusable value
Output           → Expose/display result

var.name          → Variable reference
local.name        → Local reference
terraform output  → Show outputs
```

# Terraform Notes — Part 3: State & Remote Backend

## 1. Terraform State

Terraform uses a state file to track the infrastructure it manages.

Default local state file:

```text
terraform.tfstate
```

Simple flow:

```text
Terraform Code
      ↓
Terraform State
      ↓
Actual AWS Resource
```

Example:

```text
aws_instance.app
      ↓
terraform.tfstate
      ↓
EC2 Instance ID
```

---

## 2. Important State Commands

List resources available in the current state:

```bash
terraform state list
```

Show details of a resource:

```bash
terraform state show aws_instance.app
```

Remove a resource from Terraform state:

```bash
terraform state rm aws_instance.app
```

`state rm` removes Terraform tracking only. It does **not** delete the actual AWS resource.

---

## 3. Local State

By default, Terraform stores state locally:

```text
Project Folder
└── terraform.tfstate
```

Local state is fine for personal labs.

Problem in team environments:

```text
Engineer A → Local State
Engineer B → Local State
```

Both engineers may not have the same state information.

---

## 4. Remote State

Remote backend stores Terraform state in a centralized location.

Example with AWS:

```text
Engineer A ──┐
             ├── S3 Remote State
Engineer B ──┘
```

This allows multiple systems/users to work with the same Terraform state.

---

## 5. S3 Remote Backend

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

Then initialize:

```bash
terraform init
```

If backend configuration is changed:

```bash
terraform init -reconfigure
```

For migrating existing state to a new backend:

```bash
terraform init -migrate-state
```

---

## 6. State Locking

State locking prevents multiple Terraform operations from modifying the same state simultaneously.

```text
Engineer A → Apply → State Locked
Engineer B → Cannot modify same state
```

This helps prevent conflicting state changes.

---

## 7. S3 Versioning

Enable versioning on the S3 state bucket.

It keeps previous versions of:

```text
terraform.tfstate
```

Example:

```text
terraform.tfstate
├── Version 1
├── Version 2
└── Version 3
```

If state is accidentally overwritten or damaged, a previous version can be recovered carefully.

---

## 8. State File & Git

Terraform state should normally **not be pushed to Git**.

Code:

```text
GitHub
```

State:

```text
Remote Backend / S3
```

For our temporary local labs, we can destroy resources before moving to another laptop and recreate them later.

---

## Quick Revision

```text
terraform.tfstate     → Tracks managed infrastructure
terraform state list  → List state resources
terraform state show  → Show resource details
terraform state rm    → Remove only from state

Local Backend  → State on local machine
Remote Backend → Centralized state
S3             → Can store remote state
State Locking  → Prevent concurrent state modification
S3 Versioning  → Helps recover previous state versions
```

# Terraform Notes — Part 4: Import & Drift

## 1. Terraform Import

Terraform import is used when a resource **already exists in AWS** and we want to bring it under Terraform management.

Example:

```text
Existing EC2 in AWS
        ↓
terraform import
        ↓
Terraform State
```

---

## 2. Import Process

First create a resource block:

```hcl
resource "aws_instance" "import_instance" {
}
```

Then import the existing EC2:

```bash
terraform import aws_instance.import_instance i-xxxxxxxx
```

Format:

```text
terraform import <resource-address> <actual-resource-id>
```

---

## 3. What Import Does

Traditional `terraform import` mainly adds the existing resource to **Terraform state**.

It does not automatically complete the resource configuration in `main.tf`.

After import:

```bash
terraform state list
```

Example:

```text
aws_instance.import_instance
```

---

## 4. Check Imported Resource

To see imported resource details:

```bash
terraform state show aws_instance.import_instance
```

It can show values such as:

```text
ami
instance_type
subnet_id
security groups
key_name
tags
private_ip
public_ip
```

---

## 5. Configuration After Import

After import, run:

```bash
terraform plan
```

Terraform may show missing required configuration or differences.

Example resource:

```hcl
resource "aws_instance" "import_instance" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

Process:

```text
Import
  ↓
terraform state show
  ↓
terraform plan
  ↓
Add/fix required configuration
  ↓
terraform plan again
```

Repeat until the plan shows the changes you actually want.

---

## 6. Terraform Drift

Drift happens when Terraform-managed infrastructure is changed manually outside Terraform.

Example:

Terraform code:

```text
SSH 22 → My IP
```

Someone manually changes AWS:

```text
SSH 22 → 0.0.0.0/0
```

Now:

```bash
terraform plan
```

Terraform detects the difference and plans changes to make the infrastructure match the Terraform configuration again.

---

## 7. Important Difference

```text
terraform state show
→ What Terraform currently knows about the resource

terraform plan
→ What Terraform wants to change based on the configuration
```

---

## Quick Revision

```text
terraform import
→ Bring existing resource into Terraform state

terraform state list
→ Check imported resource in state

terraform state show
→ See imported resource details

terraform plan
→ Find configuration differences

Drift
→ Infrastructure changed outside Terraform

Import does not automatically mean complete .tf code
```

# Terraform Notes — Part 5: Workspaces

## 1. Terraform Workspace

Terraform Workspace allows the **same Terraform code to maintain separate state**.

```text
Same Terraform Code
        ↓
   -------------
   ↓           ↓
default       dev
   ↓           ↓
State-1      State-2
```

Main concept:

```text
Workspace = Separate State
Code      = Same
```

---

## 2. Workspace Commands

List workspaces:

```bash
terraform workspace list
```

Create a new workspace:

```bash
terraform workspace new dev
```

Create command automatically switches to the new workspace.

Switch workspace:

```bash
terraform workspace select dev
```

Check current workspace:

```bash
terraform workspace show
```

Delete workspace:

```bash
terraform workspace delete dev
```

---

## 3. Default Workspace

Terraform initially has:

```text
default
```

Example:

```bash
terraform workspace list
```

Output:

```text
* default
  dev
```

`*` shows the currently selected workspace.

---

## 4. Separate State

Suppose EC2 exists in `default` workspace.

Then we switch to a new `dev` workspace:

```bash
terraform workspace new dev
```

Because `dev` has separate state, Terraform does not see the resource from `default` as being managed in `dev`.

So:

```bash
terraform plan
```

can plan a new resource for `dev`.

---

## 5. terraform.workspace

Current workspace name can be used inside Terraform code:

```hcl
terraform.workspace
```

Example:

```hcl
instance_type = terraform.workspace == "dev" ? "t2.micro" : "t3.micro"
```

Meaning:

```text
dev     → t2.micro
default → t3.micro
```

Conditional format:

```text
condition ? true_value : false_value
```

---

## 6. Local Workspace State

With local backend:

Default workspace:

```text
terraform.tfstate
```

Other workspaces:

```text
terraform.tfstate.d/
└── dev/
    └── terraform.tfstate
```

---

## 7. Important Point

Workspace separates **state**, not Terraform code.

```text
default → Same Code + Separate State
dev     → Same Code + Separate State
```

If environment-specific configuration is required, we can use variables, maps or conditions such as `terraform.workspace`.

---

## Quick Revision

```text
Workspace = Same code + Separate state

terraform workspace list
→ List workspaces

terraform workspace new dev
→ Create + switch to dev

terraform workspace select dev
→ Switch workspace

terraform workspace show
→ Current workspace

terraform.workspace
→ Current workspace name inside code
```

# Terraform Notes — Part 6: depends_on

## 1. What is depends_on?

Terraform normally understands resource dependencies automatically through references.

Example:

```hcl
subnet_id = aws_subnet.public.id
```

Terraform understands:

```text
Subnet → EC2
```

This is called **Implicit Dependency**.

---

## 2. Why depends_on?

Sometimes a dependency exists, but Terraform cannot identify it through a direct resource reference.

Then we explicitly define the dependency:

```hcl
depends_on = [resource_address]
```

This is called **Explicit Dependency**.

---

## 3. Example

```hcl
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "imtiyaj-dependson-lab-2026"
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  depends_on = [aws_s3_bucket.demo_bucket]

  tags = {
    Name = "depends-on-demo"
  }
}
```

Terraform will follow:

```text
S3 Bucket Create
       ↓
S3 Creation Complete
       ↓
EC2 Create
```

---

## 4. Our Practical Test

We intentionally gave the S3 bucket an invalid name.

Result:

```text
S3 Creating
     ↓
S3 Failed
     ↓
EC2 did not start
```

After fixing the S3 bucket:

```text
S3 Creating
     ↓
S3 Creation Complete
     ↓
EC2 Creating
     ↓
EC2 Creation Complete
```

This confirmed that EC2 was explicitly dependent on S3.

---

## 5. Implicit vs Explicit Dependency

```text
Implicit Dependency
→ Terraform understands automatically from resource reference

Explicit Dependency
→ We manually tell Terraform using depends_on
```

Example implicit:

```hcl
subnet_id = aws_subnet.public.id
```

Example explicit:

```hcl
depends_on = [aws_s3_bucket.demo_bucket]
```

---

## Quick Revision

```text
Terraform detects dependency automatically
→ depends_on not required

Terraform cannot detect required dependency/order
→ depends_on

Implicit Dependency → Automatic
Explicit Dependency → depends_on

depends_on = [resource_address]
```

# Terraform Notes — Part 7: count & for_each

## 1. count

`count` is used to create multiple instances of the same resource.

Example:

```hcl
resource "aws_instance" "app" {
  count         = 5
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"
}
```

Terraform creates:

```text
aws_instance.app[0]
aws_instance.app[1]
aws_instance.app[2]
aws_instance.app[3]
aws_instance.app[4]
```

`count` index starts from `0`.

---

## 2. count.index

`count.index` gives the index number of the current resource.

```hcl
tags = {
  Name = "count-demo-${count.index + 1}"
}
```

Result:

```text
app[0] → count-demo-1
app[1] → count-demo-2
app[2] → count-demo-3
app[3] → count-demo-4
app[4] → count-demo-5
```

Important:

```text
count-demo-1 = AWS Name tag
app[0]       = Terraform resource identity
```

---

## 3. Target Specific count Resources

Example: first and fifth EC2:

```text
EC2-1 → aws_instance.app[0]
EC2-5 → aws_instance.app[4]
```

Preview destroy:

```bash
terraform plan -destroy -target="aws_instance.app[0]" -target="aws_instance.app[4]"
```

Destroy:

```bash
terraform destroy -target="aws_instance.app[0]" -target="aws_instance.app[4]"
```

If code still contains:

```hcl
count = 5
```

the next normal `terraform plan` will try to recreate the missing instances because the desired count is still 5.

---

## 4. for_each

`for_each` creates multiple resources using unique keys instead of numeric indexes.

Example:

```hcl
resource "aws_instance" "app" {
  for_each = toset(["app1", "app2", "app3"])

  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = each.key
  }
}
```

Terraform identities:

```text
aws_instance.app["app1"]
aws_instance.app["app2"]
aws_instance.app["app3"]
```

---

## 5. each.key

`each.key` represents the current `for_each` key.

```hcl
tags = {
  Name = each.key
}
```

Result:

```text
app1
app2
app3
```

---

## 6. Remove a Specific Resource

Initial:

```hcl
for_each = toset(["app1", "app2", "app3"])
```

To remove only `app2`:

```hcl
for_each = toset(["app1", "app3"])
```

Terraform plans:

```text
app1 → No change
app2 → Destroy
app3 → No change
```

Because `"app2"` itself is the Terraform key/identity.

---

## 7. count vs for_each

```text
count
→ Numeric index based
→ app[0], app[1], app[2]

for_each
→ Key/name based
→ app["app1"], app["app2"], app["app3"]
```

Use:

```text
count
→ When we mainly need N similar resources

for_each
→ When resources need unique/stable identities
   and individual management
```

---

## Quick Revision

```text
count = 5
→ Creates 5 resource instances

count.index
→ Current numeric index
→ Starts from 0

for_each
→ Creates resources using keys

each.key
→ Current for_each key

count    → Index-based identity
for_each → Key-based identity
```
# Terraform Notes — Part 8: Modules

## 1. What is Terraform Module?

Terraform Module is a collection of Terraform files used to create reusable infrastructure code.

Instead of writing the same resource code multiple times, we create a module once and reuse it.

```text
Module = Reusable Terraform Code

Benefits:

Avoid code duplication
Reuse same code
Easy maintenance
Standard configuration
```

## 2. Types of Terraform Module

### Root Module (Caller)

Root Module is where we call the Child Module, Root Module provides input values to Child Module.

Example:

```hcl
module "ec2" {

  source = "../ec2-module"

  ami_id        = "ami-xxxx"
  instance_type = "t3.micro"

}
```

### Child Module

Child Module contains the original Terraform source code.

Example:

```text
ec2-module/

├── ec2.tf
├── variable.tf
└── output.tf
```

Example:

```hcl
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

}
```

Child Module contains:

- Resource code
- Variables
- Outputs

## 3. Module from Git Repository

If module code is stored in Git repository:

Flow:

```text
Git Repository

      ↓

git clone

      ↓

terraform init

      ↓

Module Download
```

Caller:

```hcl
module "ec2" {

  source = "git::https://github.com/company/ec2-module.git"

  ami_id        = "ami-xxxx"
  instance_type = "t3.micro"

}
```

`terraform init` downloads the module from Git.

## 4. Module Versioning

Module owner maintains different versions of the module.

First version:

```text
Code Change

↓

git add .

↓

git commit

↓

git tag v1.0.0

↓

git push
```

After some changes:

```text
New Code Change

↓

git add .

↓

git commit

↓

git tag v1.1.0

↓

git push
```

Caller can use a specific version:

```hcl
module "ec2" {

  source = "git::https://github.com/company/ec2-module.git?ref=v1.0.0"

}
```

Meaning:

Use only `v1.0.0` module code.

## 5. Module with Multiple Environments

Same module can be used for multiple environments.

Example:

```text
              ec2-module

                   |

        ---------------------

        |          |         |

       Dev       Test      Prod
```

Different values can be passed:

### Dev

```text
instance_type = t2.micro
```

### Test

```text
instance_type = t2.micro
```

### Prod

```text
instance_type = t3.large
```

Benefits:

- Same code reuse
- Different environment configuration
- Less code duplication
