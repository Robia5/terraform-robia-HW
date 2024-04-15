output "aws_instanceID" {
  description = "This is my instance id"
  value       = aws_instance.ec2-instance.id
}

output "MyVPC-id" {
  value = aws_vpc.MyVPC.id
}

output "MyVPC-cidrblock" {
  value = aws_vpc.MyVPC.cidr_block
}

output "subnet1-id" {
  value = aws_subnet.subnet1.id
}

output "subnet2-id" {
  value = aws_subnet.subnet2.id
}