locals {
  environment = "dev"
  server_name = "${local.environment}-web-server"
  vpc_name    = "${local.environment}-vpc"
}