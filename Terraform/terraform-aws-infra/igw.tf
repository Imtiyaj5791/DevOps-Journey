resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "My_IGW"
  }

}

