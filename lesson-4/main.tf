terraform {
    backend "s3" {
        bucket = "robia-tfstate-bucket"
        key = "dev/terraform.tfstate"
        region = "us-east-1"

        dynamodb_table = "robia-tfstate-tb"
    }
}

data "aws_ami" "ami_amazonL" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
  }
}

provider "aws" {
  region = "us-east-1"
}

# provider "aws" {
#   alias  = "oregon"
#   region = "us-west-2"
# }

locals {
  instance_type = "t2.micro"
  user_data = null
  cidr_block = "10.0.0.0/16"
  subnet_cidr1 = "10.0.1.0/24"
  subnet_cidr2 = "10.0.16.0/24"
  name = "Robia"
}

resource "aws_vpc" "MyVPC" {
  cidr_block           = local.cidr_block

  tags = {
    "Name" = "${local.name}"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tags["Name"] ]
  }
}

resource "aws_subnet" "subnet1" {
  depends_on              = [aws_vpc.MyVPC]
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = local.subnet_cidr1
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}"
  }
}

resource "aws_subnet" "subnet2" {
  depends_on              = [aws_vpc.MyVPC]
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = local.subnet_cidr2

  tags = {
    "Name" = "${local.name}"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.MyVPC.id

  tags = {
    "Name" = "${local.name}"
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = data.aws_ami.ami_amazonL.id
  instance_type = local.instance_type
  subnet_id     = aws_subnet.subnet1.id
  user_data     = local.user_data
  security_groups = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${local.name}"
  }
  
  lifecycle {
    ignore_changes = [ ami, tags["Name"] ]
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "${local.name}"
  }
}

resource "aws_route_table_association" "rtbass" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtbass2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = aws_vpc.MyVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${local.name}"
  }
}

# resource "aws_security_group" "private_sg" {
#   name   = "private_sg"
#   vpc_id = aws_vpc.vpc-oregon.id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     "Name" = "${local.name}"
#   }
# }

# resource "aws_eip" "eip" {
#   domain = "vpc"
#   instance                  = aws_instance.ec2-instance2.id
#   associate_with_private_ip = "10.0.16.43"
# }

# resource "aws_nat_gateway" "ngw" {
#   allocation_id     = aws_eip.eip2.id
#   subnet_id         = aws_subnet.subnet2.id

# tags = {
#     "Name" = "${local.name}"
#   }
#   depends_on = [aws_internet_gateway.igw]
# }