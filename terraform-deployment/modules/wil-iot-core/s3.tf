# # Only used at an AWS Event. This uploads the generate docker compose file for
# # The pre-configured Mini Pupper to the existing S3 bucket in the provided AWS Account.
# resource "aws_s3_object" "object" {
#   count  = var.mpc_upload_docker_compose_to_existing_s3_bucket ? 1 : 0
#   bucket = data.aws_ssm_parameter.mpc_existing_s3_bucket_ssm[0].value
#   key    = "docker-compose.yaml"
#   source = "${path.root}/MP_AWS_IOT/existing-minipuper/docker-compose.yaml"

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # uncomment this later
#   # etag = filemd5("${path.root}/MP_AWS_IOT/existing-minipuper/docker-compose.yaml")

#   depends_on = [local_file.docker_compose_existing_minipupper]
# }



# resource "aws_s3_bucket" "mpc_greengrass_s3_bucket" {
#   bucket_prefix = "mpc-greengrass-s3-bucket"

#   # tags = {
#   #   Name        = "My bucket"
#   #   Environment = "Dev"
#   # }
# }
