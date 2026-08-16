resource "aws_s3_bucket" "demo_bucket" {
  bucket = "imtiyaj-dependson-lab-2026"
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  depends_on = [ aws_s3_bucket.demo_bucket ]

  tags = {
    Name = "depends-on-demo"
  }
}