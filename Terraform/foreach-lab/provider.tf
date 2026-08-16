provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "app" {
  for_each = toset(["app1", "app3"])

  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  tags = {
    Name = each.key
  }
}