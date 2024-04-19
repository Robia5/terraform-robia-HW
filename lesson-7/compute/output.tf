output  "aws_security_group" {
    value = {for i, v in aws_security_group.sg : i => v.id}
}