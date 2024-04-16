data "aws_ami" "ami_amazon" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
  }
}

locals {
  instance_names = ["first", "second"]
}

resource "aws_instance" "instances" {
  count         = length(local.instance_names)
  ami           = data.aws_ami.ami_amazon.id
  instance_type = "t2.micro"

  tags = {
    Name = "${local.instance_names[count.index]}"
  }
}