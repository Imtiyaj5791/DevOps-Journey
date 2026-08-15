resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_availibility_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_availibilty_zone

  tags = {
    Name = "Private_Subnet"
  }
}