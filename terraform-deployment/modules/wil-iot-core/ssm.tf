# resource "aws_ssm_parameter" "mpc_s3_bucket" {
#   name  = "S3BucketName"
#   value = aws_s3_bucket.mpc_greengrass_s3_bucket.id
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_thing_name" {
#   name  = "MiniPupperThingName"
#   value = "MiniPupper"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_device_id" {
#   name  = "MiniPupperDeviceId"
#   value = "MiniPupper_2"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_device_name" {
#   name  = "MiniPupperDeviceName"
#   value = "MiniPupper"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_short_name" {
#   name  = "MiniPupperShortName"
#   value = "MP"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_computer_module" {
#   name  = "MiniPupperComputerModule"
#   value = "RaspberryPi4B"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_manufacturer" {
#   name  = "MiniPupperManufacturer"
#   value = "Mangdang"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_model" {
#   name  = "MiniPupperModel"
#   value = "Mini Pupper 2"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_device" {
#   name  = "MiniPupperDevice"
#   value = "Mini Pupper"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_registered_owner" {
#   name  = "MiniPupperRegisteredOwner"
#   value = "Workshop Attendee"
#   type  = "String"
# }
# resource "aws_ssm_parameter" "mpc_primary_location" {
#   name  = "MiniPupperPrimaryLocation"
#   value = "re:Invent"
#   type  = "String"
# }
