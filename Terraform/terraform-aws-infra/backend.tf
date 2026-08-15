terraform {
  backend "s3" {
    bucket = "imtiyaj-s3-practice-2026"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}