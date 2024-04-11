resource "aws_instance" "ec2-instance"{
  ami            = data.aws_ami.ami_amazonL.id
  instance_type  = var.instance_type
  subnet_id      = aws_subnet.subnet2.id
  user_data      = var.user-data

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_vpc" "MyVPC" {
  cidr_block = var.cidrblock_MyVPC

  tags = {
    "Name" = var.instance_name
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = var.subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
   "Name"= var.instance_name
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = var.subnet2_cidr
  availability_zone = "us-east-1b"

  tags = {
    "Name" = var.instance_name
  }
}