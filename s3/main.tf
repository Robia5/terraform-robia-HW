# Creating an S3 bucket to store static content in a prod environment

resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "robia-prod-exemple-website" # The unique name of the S3 bucket

}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.static_website_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_object_lock_configuration" "example" {
#   bucket = aws_s3_bucket.static_website_bucket.id

#   rule {
#     default_retention {
#       mode = "COMPLIANCE"
#       days = 5
#     }
#   }
# }
#   routing_rule {
#     condition {
#       key_prefix_equals = "docs/"
#     }
#     redirect {
#       replace_key_prefix_with = "documents/"
#     }
#   }

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website_bucket.arn}/*"
      }
    ]
  })
}

# resource "aws_s3_bucket_ownership_controls" "control" {
#   bucket = aws_s3_bucket.static_website_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "web-block" {
#   bucket = aws_s3_bucket.static_website_bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "acl" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.control,
#     aws_s3_bucket_public_access_block.web-block,
#   ]

#   bucket = aws_s3_bucket.static_website_bucket.id
#   acl    = "public-read"
# }