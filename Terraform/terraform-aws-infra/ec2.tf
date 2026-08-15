resource "aws_instance" "App" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.SG.id]
  key_name               = aws_key_pair.terraform-key.key_name

  tags = {
    Name        = local.server_name
    Environment = local.environment
    Test        = "restore-lab"
  }
}