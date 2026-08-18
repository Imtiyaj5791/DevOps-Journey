module "ec2" {
  source = "git::https://github.com/Imtiyaj5791/DevOps-Journey.git//Terraform/module-lab/ec2-module"

  ami_id = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
}