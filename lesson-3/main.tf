resource "aws_vpc" "MyVPC" {
  #   depends_on = [ aws_instance.ec2-instance ]
  cidr_block = var.cidrblock_MyVPC
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.MyVPC.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.foo.id
  route_table_id = aws_route_table.bar.id
}


resource "aws_subnet" "subnet1" {
  #   depends_on        = [ aws_vpc.MyVPC ]
  vpc_id                  = aws_vpc.MyVPC.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVPC.id
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
    "Name" = var.instance_name
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = data.aws_ami.ami_amazonL.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet1.id
  user_data     = var.user-data

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_vpc" "vpc-oregon" {

  #   depends_on = [ aws_instance.ec2-instance2 ]
  provider   = aws.oregon
  cidr_block = var.cidrblock_MyVPC

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_subnet" "subnet2" {
  #   depends_on        = [ aws_vpc.vpc-oregon ]
  provider = aws.oregon
  vpc_id     = aws_vpc.vpc-oregon.id
  cidr_block = var.subnet2_cidr
  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_security_group" "private_sg" {
  provider = aws.oregon
  name   = "private_sg"
  vpc_id = aws_vpc.vpc-oregon.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = var.instance_name
  }
}


resource "aws_instance" "ec2-instance2" {
  provider      = aws.oregon
  ami           = "ami-0395649fbe870727e"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet2.id
  user_data     = var.user-data

  tags = {
    "Name" = var.instance_name
  }
}

resource "aws_security_group" "private_sg" {
  provider = aws.oregon
  name   = "private_sg"
  vpc_id = aws_vpc.vpc-oregon.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = var.instance_name
  }
}


resource "aws_eip" "eip" {
  provider = aws.oregon
  domain = "vpc"

  instance                  = aws_instance.ec2-instance2.id
  associate_with_private_ip = "10.0.16.43"
  
}

resource "aws_internet_gateway" "igw-oregon" {
  provider = aws.oregon
  vpc_id = aws_vpc.vpc-oregon.id

  tags = {
    Name = "main"
  }
}
resource "aws_nat_gateway" "ngw" {
  provider = aws.oregon
  allocation_id     = aws_eip.eip2.id
  subnet_id         = aws_subnet.subnet2.id

  tags = {
    "Name" = var.instance_name
  }
  # depends_on = [aws_internet_gateway.igw]
}