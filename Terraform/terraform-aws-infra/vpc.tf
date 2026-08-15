resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = local.vpc_name
    Environment = local.environment
  }
}
