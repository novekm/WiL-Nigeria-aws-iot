# # NOTE - It is not a best practice to mark SSM Parameters as 'nonsensitive' because this means the values will be displayed in the terminal. However, this is added in to make it easier to see during a workshop setting. We HIGHLY recommend avoiding this in production environments.

# output "mpc_existing_s3_bucket_ssm" {
#   value = var.lookup_existing_general_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_s3_bucket_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_thing_name_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_thing_name_ssm[0].value) : null
# }
# output "mpc_existing_minipupper_device_id_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_device_id_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_device_name_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_device_name_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_short_name_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_short_name_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_computer_module_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_computer_module_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_manfacturer_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_manfacturer_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_model_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_model_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_device_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_device_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_registered_owner_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_registered_owner_ssm[0].value) : null
# }

# output "mpc_existing_minipupper_primary_location_ssm" {
#   value = var.lookup_existing_minipuppers_ssm_parameters ? nonsensitive(data.aws_ssm_parameter.mpc_existing_minipupper_primary_location_ssm[0].value) : null
# }

