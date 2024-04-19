data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "robia-tfstate-bucket"
    key = "lesson-7/networking/terraform.tfstate"
    region = "us-east-1"
  }
}
locals {
  sg = {
    sg1 = [22],
    sg2 = [80],
    sg3 = [22, 80, 443]
  }
  instances = {
    instance1 = {
        instance_type = "t2.micro"
        sg            = [aws_security_group.sg["sg1"].id]
        subnet_id = data.terraform_remote_state.networking.outputs.pub-subnets-id["public_subnet1"]
        # vpc_security_group_ids = aws_security_group.sg[sg1].id
    }
    instance2 = {
        instance_type = "t2.micro"
        sg            = [aws_security_group.sg["sg2"].id]
        subnet_id = data.terraform_remote_state.networking.outputs.pub-subnets-id["public_subnet2"]
        # vpc_security_group_ids = aws_security_group.sg[sg2].id
    }
    instance3 = {
        instance_type = "t2.micro"
        sg            = [aws_security_group.sg["sg3"].id]
        subnet_id = data.terraform_remote_state.networking.outputs.private-subnets-id["private_subnet3"]
        # vpc_security_group_ids = aws_security_group.sg[sg3].id
    }
  }
}
data "aws_ami" "ami_amazon" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "instances" {
  ami = data.aws_ami.ami_amazon.id
  for_each = local.instances
  subnet_id = each.value.subnet_id
  instance_type = each.value.instance_type

  vpc_security_group_ids = each.value.sg

  tags = {
    Name = each.key
  }
  }

resource "aws_security_group" "sg" {
  for_each = local.sg
  name = each.key
  vpc_id = data.terraform_remote_state.networking.outputs.vpc

  dynamic "ingress" {
    for_each = local.sg[each.key]
    
    content {
      from_port   = ingress.value
      to_port     = ingress.value == 443 ? 443 : ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = each.key
  }
}