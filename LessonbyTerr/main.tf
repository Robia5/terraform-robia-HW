provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance1" {
  ami           = "ami-080e1f13689e07408"  # Ubuntu AMI ID
  instance_type = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "Instance1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-051f8a213df8bc089"  # Amazon Linux AMI ID
  instance_type = "t3.micro"
  subnet_id     = "subnet-0cb92d91f4eae94fd"
  associate_public_ip_address = false

  tags = {
    Name = "Instance2"
  }
}

resource "aws_instance" "instance3" {
  ami           = "ami-080e1f13689e07408"  # Ubuntu AMI ID
  instance_type = "t2.micro"

  monitoring    = true
  associate_public_ip_address = false

  tags = {
    Name = "Instance3"
  }
}