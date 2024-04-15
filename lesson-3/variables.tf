variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  description = "Instance name"
}

variable "user-data" {
  default = null
}

variable "cidrblock_MyVPC" {
  type = string
}



variable "subnet1_cidr" {
  type = string
}

variable "subnet2_cidr" {
  type = string
}