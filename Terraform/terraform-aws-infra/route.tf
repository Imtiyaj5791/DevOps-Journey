resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private_RT"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.Public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.Public_RT.id

}