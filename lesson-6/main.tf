terraform {
    backend "s3" {
        bucket = "robia-tfstate-bucket"
        key = "terraform.tfstate"
        workspace_key_prefix = "env"
        region = "us-east-1"
        dynamodb_table = "robia-tfstate-tb"
    }
}

locals {
    dev = "dev"
    bucket-1 = "robia-dev-bucket"
    prod = "prod"
    bucket-2 = "robia-prod-bucket"
    stage = "stage"
    bucket-3 = "robia-stage-bucket"
    cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "prod-vpc" {
  count = terraform.workspace == "prod" ? 1 : 0
  cidr_block = local.cidr_block
}

resource "aws_s3_bucket" "dev-bucket" {
  count = terraform.workspace == "dev" ? 1 : 0
  bucket = local.bucket-1

  tags = {
    "Name" = "${terraform.workspace}-bucket"
  }
}

resource "aws_s3_bucket" "prod-bucket" {
  count = terraform.workspace == "prod" ? 1 : 0
  bucket = local.bucket-2

  tags = {
    "Name" = "${terraform.workspace}-bucket"
  }
}

resource "aws_s3_bucket" "stage-bucket" {
  count = terraform.workspace == "stage" ? 1 : 0
#   bucket = local.bucket-3

  tags = {
    "Name" = "${terraform.workspace}-bucket"
  }
}