// This is a tempclate file for a basic deployment.
// Modify the parameters below with actual values
module "wil-iot-core" {
  // location of the module - can be local or git repo
  source = "./modules/wil-iot-core"

  project_prefix = "WiL"

  create_amplify_app = false // default value
  create_graphql_api = false // default value

  create_codecommit_repo = true // enabled to store code in CodeCommit Git Repo within the AWS Account

  # - Network Information -
  # Note: For added security, eventually these values could be stored in SSM parameter store,
  # and fetched via SSM Data Sources. However, that would require users to manually enter these
  # values before running Terraform apply to provision resources.
  # however that would require users to manually enter them before deploying the Terraform code.
  # For production workloads, we strongly advise against hardcoding sensitive values.

  # Primary WiFi - REQUIRED
  wifi_ssid     = "" // enter SSID for the primary local network you want your IoT devices to connect to
  wifi_password = "" // enter password for the primary local network you want your IoT devices to

  # - IoT -
  # Dynamic Creation of IoT Things for Climate Sensor Arrays and Flow Sensor Arrays
  // Enter an object for each Climate Sensor Array you would like to connect

  wil_climate_sensor_arrays = {
    // no spaces allowed in strings
    ClimateSensorArray1 : {
      name       = "WiL_Nigeria_ClimateSensor_Array1"
      short_name = "CSA1"
    },
    ClimateSensorArray2 : {
      name       = "WiL_Nigeria_ClimateSensor_Array2"
      short_name = "CSA2"
    },


  }

  // Enter an object for each Flow Sensor Array you would like to connect
  wil_flow_sensor_arrays = {
    // no spaces allowed in strings
    FlowSensorArray1 : {
      name       = "WiL_Nigeria_FlowSensor_Array1"
      short_name = "FSA1"
    },
    FlowSensorArray2 : {
      name       = "WiL_Nigeria_FlowSensor_Array2"
      short_name = "FSA2"
    },

  }

  # # - Cognito -
  # # Admin Users to create
  # admin_cognito_users = {
  #   // replace with your desired cognito users
  #   NarutoUzumaki : {
  #     username       = "nuzumaki"
  #     given_name     = "Naruto"
  #     family_name    = "Uzumaki"
  #     email          = "nuzumaki@hokage.com"
  #     email_verified = true // no touchy
  #   },
  #   # SasukeUchiha : {
  #   #   username       = "suchiha"
  #   #   given_name     = "Sasuke"
  #   #   family_name    = "Uchiha"
  #   #   email          = "suchiha@chidori.com"
  #   #   email_verified = true // no touchy
  #   # },
  # }
  # # Standard Users to create
  # # mpc_standard_cognito_users = {
  # #   // replace with your desired cognito users
  # #   DefaultStandardUser : {
  # #     username       = "default"
  # #     given_name     = "Default"
  # #     family_name    = "User"
  # #     email          = "default@example.com"
  # #     email_verified = true // no touchy
  # #   }
  # # }
}
