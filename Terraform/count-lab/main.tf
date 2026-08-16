resource "aws_instance" "app" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  count = 5

  tags = {
    Name = "count-demo-${count.index + 1}"
  }
}