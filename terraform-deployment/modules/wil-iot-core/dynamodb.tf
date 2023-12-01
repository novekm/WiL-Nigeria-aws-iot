// Generate UUID for DynamoDB Tables
resource "random_uuid" "dynamodb_tables" {
}

// DynamoDB Table for Mini Puppers Metadata
resource "aws_dynamodb_table" "iot_devices" {
  name           = "${var.project_prefix}_iot_devices-${random_uuid.dynamodb_tables.result}" // No touchy
  billing_mode   = var.devices_billing_mode
  read_capacity  = var.devices_read_capacity
  write_capacity = var.devices_write_capacity
  hash_key       = "DeviceId" // Partition Key
  # range_key      = "-" // Sort Key

  attribute {
    name = "DeviceId"
    type = "S"
  }

  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

// DynamoDB Table for MPC Devices MQTT Messages
resource "aws_dynamodb_table" "iot_devices_mqtt" {
  name           = "${var.project_prefix}_iot_devices_mqtt-${random_uuid.dynamodb_tables.result}" // No touchy
  billing_mode   = var.devices_billing_mode
  read_capacity  = var.devices_read_capacity
  write_capacity = var.devices_write_capacity
  hash_key       = "MessageId" // Partition Key
  range_key      = "DeviceId"  // Sort Key

  attribute {
    name = "MessageId"
    type = "S"
  }
  attribute {
    name = "DeviceId"
    type = "S"
  }

  global_secondary_index {
    name     = "DeviceIdIndex"
    hash_key = "DeviceId"
    # range_key          = "Timestamp"
    write_capacity  = 10
    read_capacity   = 10
    projection_type = "ALL"
    # projection_type = "INCLUDE"
    # non_key_attributes = ["DeviceId"]
  }


  # Workaround for "ValidationException: TimeToLive is already disabled"
  # when running terraform apply twice
  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = local.ttl[0].ttl_attribute
    }
  }

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

# Create item in DynamoDB table item for each Climate Sensor Array defined in main.tf
resource "aws_dynamodb_table_item" "wil_climate_sensor_arrays_item" {
  for_each   = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  table_name = aws_dynamodb_table.iot_devices.name
  hash_key   = aws_dynamodb_table.iot_devices.hash_key

  item = jsonencode({
    "${aws_dynamodb_table.iot_devices.hash_key}" : { "S" : "${each.value.name}_${each.value.short_name}" },
    "DeviceName" : { "S" : "${each.value.name}" },
    "ShortName" : { "S" : "${each.value.short_name}" },
    "ComputerModule" : { "S" : "${each.value.computer_module}" },
    "Manufacturer" : { "S" : "${each.value.manufacturer}" },
    "Model" : { "S" : "${each.value.model}" },
    "Device" : { "S" : "${each.value.device}" },
    "RegisteredOwner" : { "S" : "${each.value.registered_owner}" },
    "PrimaryLocation" : { "S" : "${each.value.primary_location}" },
  })
}

# Create item in DynamoDB table item for each Flow Sensor Array defined in main.tf
resource "aws_dynamodb_table_item" "wil_flow_sensor_arrays_item" {
  for_each   = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  table_name = aws_dynamodb_table.iot_devices.name
  hash_key   = aws_dynamodb_table.iot_devices.hash_key

  item = jsonencode({
    "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${each.value.name}_${each.value.short_name}" },
    "DeviceName" : { "S" : "${each.value.name}" },
    "ShortName" : { "S" : "${each.value.short_name}" },
    "ComputerModule" : { "S" : "${each.value.computer_module}" },
    "Manufacturer" : { "S" : "${each.value.manufacturer}" },
    "Model" : { "S" : "${each.value.model}" },
    "Device" : { "S" : "${each.value.device}" },
    "RegisteredOwner" : { "S" : "${each.value.registered_owner}" },
    "PrimaryLocation" : { "S" : "${each.value.primary_location}" },
  })
}

# # Create item in DynamoDB table for the EXISTING Mini Pupper (values coming from existing SSM Parameters)
# resource "aws_dynamodb_table_item" "mpc_existing_devices_item" {
#   count      = var.lookup_existing_minipuppers_ssm_parameters ? 1 : 0
#   table_name = aws_dynamodb_table.mpc_devices.name
#   hash_key   = aws_dynamodb_table.mpc_devices.hash_key

#   item = jsonencode({
#     # "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${random_uuid.minipupper_device_id[each.key].result}" },
#     "${aws_dynamodb_table.mpc_devices.hash_key}" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_device_id_ssm[0].value}" },
#     "DeviceName" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_device_name_ssm[0].value}" },
#     "ShortName" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_short_name_ssm[0].value}" },
#     "ComputerModule" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_computer_module_ssm[0].value}" },
#     "Manufacturer" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_manfacturer_ssm[0].value}" },
#     "Model" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_model_ssm[0].value}" },
#     "Device" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_device_ssm[0].value}" },
#     "RegisteredOwner" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_registered_owner_ssm[0].value}" },
#     "PrimaryLocation" : { "S" : "${data.aws_ssm_parameter.mpc_existing_minipupper_primary_location_ssm[0].value}" },
#   })
# }

