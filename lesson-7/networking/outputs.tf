output "vpc" {
    value = aws_vpc.vpc.id
}
output "pub-subnets-id" {
    value = {for i, v in aws_subnet.pub-subnets : i => v.id}
}
output "private-subnets-id" {
    value = {for i, v in aws_subnet.private-subnets : i => v.id}
}