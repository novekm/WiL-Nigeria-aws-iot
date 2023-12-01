resource "aws_s3_bucket" "greengrass_s3_bucket" {
  bucket_prefix = "wil-greengrass-s3-bucket"

  # tags = {
  #   Name        = "My bucket"
  #   Environment = "Dev"
  # }
}
