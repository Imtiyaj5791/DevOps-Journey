resource "aws_security_group" "import_sg" {
  vpc_id = aws_vpc.main.id
  name = "import-lab-sg"
  description = "import-lab-sg"

  ingress {

    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }

  egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = [ "0.0.0.0/0"]

  }
}

resource "aws_instance" "import_instance" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  tags = {
    Name = "import"
  }
}