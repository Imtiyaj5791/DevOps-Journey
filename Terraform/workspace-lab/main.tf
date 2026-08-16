resource "aws_instance" "workspace_demo" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = terraform.workspace == "dev" ? "t2.micro" : "t3.micro"

  tags = {
    Name = "workspace-demo"
  }
}