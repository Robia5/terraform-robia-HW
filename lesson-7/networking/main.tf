terraform {
    backend "s3" {
        bucket = "robia-tfstate-bucket"
        key = "lesson-7/networking/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "robia-tfstate-tb"
    }
}

variable "vpc" {
  default = "10.0.0.0/16"
}

variable "tagName" {
  default = "robia"
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc

  tags = {
    "Name" = "${var.tagName}-vpc"
  }
}

locals {
  public_subnets = {
    public_subnet1 = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true

    }
    public_subnet2 = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
    }
    public_subnet3 = {
      cidr_block              = "10.0.3.0/24"
      availability_zone       = "us-east-1c"
      map_public_ip_on_launch = true
    }
  }

  private_subnets = {
    privet_subnet1 = {
      cidr_block              = "10.0.4.0/24"
      availability_zone       = "us-east-1d"
      map_public_ip_on_launch = false
    }
    private_subnet2 = {
      cidr_block              = "10.0.5.0/24"
      availability_zone       = "us-east-1e"
      map_public_ip_on_launch = false
    }
    private_subnet3 = {
      cidr_block              = "10.0.6.0/24"
      availability_zone       = "us-east-1f"
      map_public_ip_on_launch = false
    }
  }
}

resource "aws_subnet" "pub-subnets" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = local.public_subnets
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    "Name" = each.key
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = local.private_subnets
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    "Name" = each.key
  }
}