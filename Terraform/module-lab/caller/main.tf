module "ec2" {
  source = "../ec2-module"

   ami_id        = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
}
