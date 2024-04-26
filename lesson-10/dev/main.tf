# data "terraform_remote_state" "foo" {
#   backend = "remote"

#   config = {
#     organization = "company"

#     workspaces = {
#       name = "workspace"
#     }
#   }
# }


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}