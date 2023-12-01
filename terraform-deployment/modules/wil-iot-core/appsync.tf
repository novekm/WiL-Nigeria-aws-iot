# API Data Source (Metadata DynamoDB Table)
resource "aws_appsync_datasource" "appsync_dynamodb_datasource" {
  count            = var.create_graphql_api ? 1 : 0
  api_id           = aws_appsync_graphql_api.appsync_graphql_api.id
  name             = "${var.project_prefix}_device_metadata_dynamodb_datasource"
  service_role_arn = aws_iam_role.appsync_dynamodb_restricted_access[0].arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.iot_devices.name
  }
}

# API Data Source (MQTT Messages DynamoDB Table)
resource "aws_appsync_datasource" "mqtt_appsync_dynamodb_datasource" {
  count            = var.create_graphql_api ? 1 : 0
  api_id           = aws_appsync_graphql_api.appsync_graphql_api.id
  name             = "${var.project_prefix}_device_mqtt_dynamodb_datasource"
  service_role_arn = aws_iam_role.appsync_dynamodb_restricted_access[0].arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.iot_devices_mqtt.name
  }
}

# API
resource "aws_appsync_graphql_api" "appsync_graphql_api" {
  count               = var.create_graphql_api ? 1 : 0
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = var.appsync_graphql_api_name != null ? var.appsync_graphql_api_name : "${var.project_prefix}_api"

  user_pool_config {
    aws_region     = data.aws_region.current.name
    default_action = "ALLOW"
    user_pool_id   = aws_cognito_user_pool.mpc_user_pool.id
  }


  schema = <<EOF
type IoTDevice  @aws_auth(cognito_groups: ["Admin", "Standard"])  {
  deviceID: String!
  time: String
  humidity: String
  flowrate_lpm: String
  flowrate_total: Float
  temperature_C: String
  temperature_F: String
  soilmoisturevalue: String
  soilmoisture: String
}

type IoTDevices {
  devices: [IoTDevice!]!
  nextToken: String
  @aws_auth(cognito_groups: ["Admin", "Standard"])
}

type IoTMessage @aws_auth(cognito_groups: ["Admin", "Standard"])  {
  MessageId: String!
  Timestamp: String
  IoTTopic: String
  DeviceId: String!
  DeviceName: String
  ShortName: String
  ComputerModule: String
  Manufacturer: String
  Model: String
  Device: String
  RegisteredOwner: String
  PrimaryLocation: String
  Message: String!
}


type IoTMessages {
  messages: [IoTMessage!]!
  nextToken: String
  @aws_auth(cognito_groups: ["Admin", "Standard"])
}


type Query {
  listIoTDevices(limit: Int, nextToken: String): IoTDevices @aws_auth(cognito_groups: ["Admin", "Standard"])
  getIoTDevice(DeviceId: String!): IoTDevice @aws_auth(cognito_groups: ["Admin", "Standard"])

  listIoTMessages(limit: Int, nextToken: String): IoTMessages @aws_auth(cognito_groups: ["Admin", "Standard"])
  getIoTMessage(MessageId: String!): IoTMessage @aws_auth(cognito_groups: ["Admin", "Standard"])

  listIoTMessagesByDeviceId(DeviceId: String!, limit: Int, nextToken: String): IoTMessages! @aws_auth(cognito_groups: ["Admin", "Standard"])

}

## type Mutation {
##   deleteOneMiniPupper(DeviceId: String!): IoTDevice
##   @aws_auth(cognito_groups: ["Admin",])
## }

schema {
  query: Query
  # mutation: Mutation
}

EOF
}

# - APPSYNC JS RESOLVERS -
# Resolvers
# UNIT type resolver (default)
# Query - Get a single Mini Pupper (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_get_iot_device" {
  count       = var.create_graphql_api ? 1 : 0
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "getIoTDevice"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/getIoTDevice.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - List all Mini Puppers (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_list_iot_devices" {
  count       = var.create_graphql_api ? 1 : 0
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "listIoTDevices"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/listIoTDevices.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - Get a IoT Message (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_get_iot_message" {
  count       = var.create_graphql_api ? 1 : 0
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_mqtt_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "getIoTMessage"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/getIoTMessage.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - List all IoT Messages (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_list_iot_messages" {
  count       = var.create_graphql_api ? 1 : 0
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_mqtt_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "listIoTMessages"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/listIoTMessages.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}

# Query - List all IoT Messages by Device Id (APPSYNC_JS)
resource "aws_appsync_resolver" "mpc_appsync_resolver_query_list_iot_messages_by_device_id" {
  count       = var.create_graphql_api ? 1 : 0
  api_id      = aws_appsync_graphql_api.mpc_appsync_graphql_api.id
  data_source = aws_appsync_datasource.mpc_mqtt_appsync_dynamodb_datasource.name
  type        = "Query"
  field       = "listIoTMessagesByDeviceId"
  kind        = "UNIT"
  code        = file("${path.module}/appsync_js_resolvers/listIoTMessagesByDeviceId.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

}













