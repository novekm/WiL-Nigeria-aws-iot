// Takes a long time when destroying. On AWS side, ThingType is marked as 'deprecated'
// and cane take some time to be deleted after (around 4-5min)
// Create IoT Thing Type for all Mini Puppers
# resource "aws_iot_thing_type" "minipupper" {
#   name = "MiniPupper"
#   properties {
#     description = "Mini Puppper Robotic Dog"

#   }

#   tags = merge(
#     # {
#     #   "AppName" = var.mpc_app_name
#     # },
#     var.tags,
#   )

# }

// Create IoT Thing for each Climate Sensor Array user defines
resource "aws_iot_thing" "wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  name     = each.value.name
  # thing_type_name = aws_iot_thing_type.minipupper.name

  attributes = {
    short_name = each.value.short_name
  }
}
// Create IoT Thing for each Flow Sensor Array user defines
resource "aws_iot_thing" "wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  name     = each.value.name
  # thing_type_name = aws_iot_thing_type.minipupper.name

  attributes = {
    short_name = each.value.short_name
  }
}

// Create IoT Thing Group for all Climate Sensor Arrays
resource "aws_iot_thing_group" "wil_climate_sensor_array_fleet" {
  count = var.create_wil_climate_sensor_array_fleet_iot_thing_group ? 1 : 0
  name  = "${var.project_prefix}_climate_sensor_array_Fleet"
  properties {
    description = "Group containing all ${var.project_prefix} Climate Sensor Arrays."
  }
}
// Create IoT Thing Group for all Flow Sensor Arrays
resource "aws_iot_thing_group" "wil_flow_sensor_array_fleet" {
  count = var.create_wil_flow_sensor_array_fleet_iot_thing_group ? 1 : 0
  name  = "${var.project_prefix}_flow_sensor_array_Fleet"
  properties {
    description = "Group containing all ${var.project_prefix} Flow Sensor Arrays."
  }
}

// Assign Climate Sensor Arrays to IoT Thing Group
resource "aws_iot_thing_group_membership" "wil_climate_sensor_array_fleet" {
  for_each         = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.wil_climate_sensor_array_fleet[0].name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.wil_climate_sensor_arrays
  ]
}

// Assign Flow Sensor Arrays to IoT Thing Group
resource "aws_iot_thing_group_membership" "wil_flow_sensor_array_fleet" {
  for_each         = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  thing_name       = each.value.name
  thing_group_name = aws_iot_thing_group.wil_flow_sensor_array_fleet[0].name

  override_dynamic_group = true

  depends_on = [
    aws_iot_thing.wil_flow_sensor_arrays
  ]
}



// Create IoT Certificate Dynamically for each Climate Sensor Array
resource "aws_iot_certificate" "cert_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays
  active   = true
}
// Create IoT Certificate Dynamically for each Flow Sensor Array
resource "aws_iot_certificate" "cert_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays
  active   = true
}

// Create IoT Policy - Climate Sensor Arrays
resource "aws_iot_policy" "pubsub_wil_climate_sensor_arrays" {
  name = "ClimateSensorArrayPubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
// Create IoT Policy - Flow Sensor Arrays
resource "aws_iot_policy" "pubsub_wil_flow_sensor_arrays" {
  name = "FlowSensorArrayPubSubToAnyTopic"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
// Policies have targets - currently these can include certificates, identities, and
// thing groups. Device certificates are installed on each Gas Sensor via the
// .ino sketch. This allows the devices to use the policy and have permissions
// for what the policy permits.

// Policy Attachment - Climate Sensor Arrays
resource "aws_iot_policy_attachment" "att_wil_climate_sensor_arrays" {
  for_each = var.wil_climate_sensor_arrays == null ? {} : var.wil_climate_sensor_arrays

  policy = aws_iot_policy.pubsub_wil_climate_sensor_arrays.name
  target = aws_iot_certificate.cert_wil_climate_sensor_arrays[each.key].arn
}
// Policy Attachment - Flow Sensor Arrays
resource "aws_iot_policy_attachment" "att_wil_flow_sensor_arrays" {
  for_each = var.wil_flow_sensor_arrays == null ? {} : var.wil_flow_sensor_arrays

  policy = aws_iot_policy.pubsub_wil_flow_sensor_arrays.name
  target = aws_iot_certificate.cert_wil_flow_sensor_arrays[each.key].arn
}

# Create IoT Rule to send MQTT from AWS IoT to Timestream Table
resource "aws_iot_topic_rule" "devices_iot_to_timestream" {
  name        = "IOT_TO_TIMESTREAM"
  description = "IoT Rule to send MQTT from AWS IoT to Timestream Table"
  enabled     = true
  # sql         = "SELECT * FROM '${var.iot_topic_prefix}/1'"
  sql = "SELECT * FROM 'device/+/+'"

  sql_version = "2016-03-23"

  timestream {
    database_name = aws_timestreamwrite_database.timestream-db.database_name
    table_name    = aws_timestreamwrite_table.timestream-table.table_name
    role_arn      = aws_iam_role.iot_to_timestream_restricted_access[0].arn
    dimension {
      name  = "deviceID"
      value = "$${deviceID}"
    }
    timestamp {
      unit  = "MILLISECONDS"
      value = "$${timestamp()}"
    }
  }

}

# # Create IoT Rule to send MQTT from AWS IoT to DynamoDB Table
# resource "aws_iot_topic_rule" "devices_iot_to_dynamodb" {
#   name        = "IOT_TO_DYNAMODB"
#   description = "IoT Rule to send MQTT from AWS IoT to DynamoDB Table"
#   enabled     = true
#   # sql         = "SELECT * FROM '${var.iot_topic_prefix}/1'"
#   sql = "SELECT * FROM 'device/+/+'"

#   sql_version = "2016-03-23"

#   dynamodbv2 {
#     put_item {
#       table_name = aws_dynamodb_table.iot_devices_mqtt.name
#     }
#     role_arn = aws_iam_role.iot_to_dynamodb_restricted_access[0].arn
#   }

# }



# # Create AWS Greengrass Component
# resource "awscc_greengrassv2_component_version" "wil_greengrass_component" {
#   count = var.create_greengrass_component ? 1 : 0

#   inline_recipe = <<-EOH
# RecipeFormatVersion: '2020-01-25'
# ComponentName: com.example.ros.pupper.301workshop
# ComponentVersion: '1.0.0'
# ComponentDescription: 'The ROS Pupper Application'
# ComponentPublisher: Amazon
# ComponentDependencies:
#   aws.greengrass.DockerApplicationManager:
#     VersionRequirement: ">=2.0.0 <2.1.0"
#   aws.greengrass.TokenExchangeService:
#     VersionRequirement: ">=2.0.0 <2.1.0"
# ComponentConfiguration:
#   DefaultConfiguration:
#     auto_start: True
# Manifests:
#   - Platform:
#       os: all
#     Lifecycle:
#         Bootstrap:
#           RequiresPrivilege: True
#           Script: |
#             echo "Bootstrapping the robot application! as root This runs only once during the deployment."
#             cat << EOF > {artifacts:path}/.env
#             AUTO_START={configuration:/auto_start}
#             SVCUID=$SVCUID
#             AWS_GG_NUCLEUS_DOMAIN_SOCKET_FILEPATH_FOR_COMPONENT=$AWS_GG_NUCLEUS_DOMAIN_SOCKET_FILEPATH_FOR_COMPONENT
#             EOF
#             chown ggc_user:ggc_group {artifacts:path}/.env
#         Install:
#           Script: |
#             echo "Installing the robot application! This will run everytime the Greengrass core software is started."
#         Run:
#           Script: |
#             echo "Running the robot application! This is the main application execution script."
#             AWS_IOT_ENDPOINT=${data.aws_iot_endpoint.current.endpoint_address} docker-compose -f /docker-compose.yaml up
#         Shutdown: |
#             echo "Shutting down the robot application! This will run each time the component is stopped."
#             docker-compose -f /docker-compose.yaml down

# EOH

# }

# # Create AWS Greengrass Deployment
# resource "awscc_greengrassv2_deployment" "wil_greengrass_deployment" {
#   count = var.create_greengrass_deployment ? 1 : 0

#   # target_arn      = aws_iot_thing_group.minipupper_fleet.arn
#   target_arn      = "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:thinggroup/MiniPupper_Fleet"
#   deployment_name = "Deployment for MiniPupper_Fleet"
#   components = {
#     "aws.greengrass.Cli" = {
#       component_version = "2.12.0",
#     },
#     "${awscc_greengrassv2_component_version.wil_greengrass_component[0].component_name}" = {
#       component_version = "1.0.0",
#     }
#   }

# }
