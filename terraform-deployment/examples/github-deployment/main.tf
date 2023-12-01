# TODO - UPDATE THIS

// This is a tempclate file for a basic deployment.
// Modify the parameters below with actual values
module "minipupper-iot-core" {
  // location of the module - can be local or git repo
  source = "./modules/minipupper-iot-core"

  # - Network Information -
  # Note: For added security, eventually these values could be stored in SSM parameter store,
  # and fetched via SSM Data Sources. However, that would require users to manually enter these
  # values before running Terraform apply to provision resources.
  # however that would require users to manually enter them before deploying the Terraform code.
  # For production workloads, we strongly advise against hardcoding sensitive values.

  # Primary WiFi - REQUIRED
  mpc_wifi_ssid_1     = "" // enter SSID for the primary local network you want devices to connect to
  mpc_wifi_password_1 = "" // enter password for the primary local network you want devices to

  # Conditional Data Source fetch of existing values in SSM Parameter store.
  lookup_existing_minipuppers_ssm_parameters = false

  # Conditional Creation of Greengrass Component and Greengrass Deployment.
  create_greengrass_component  = false
  create_greengrass_deployment = false

  # - Amplify App -
  # Connect Amplify to GitHub
  mpc_existing_repo_url          = "https://github.com/your-repo-url"
  lookup_ssm_github_access_token = true                      // set to true if the resource exists in your AWS Account
  ssm_github_access_token_name   = "your-ssm-parameter-name" // name of the paramater in SSM

  # - IoT -
  # Dynamic Creation of IoT Things for Mini Puppers and Gas Sensors
  // Enter an object for each gas sensor you would like to connect

  mpc_gas_sensors = {
    // no spaces allowed in strings
    Gas1 : {
      name             = "Gas1"
      short_name       = "G1"
      computer_module  = "ESP32"
      manufacturer     = "M5Stack"
      model            = "M5StickC-Plus"
      device           = "Gas Sensor"
      registered_owner = "Workshop Participant" // Replace with your name
      primary_location = "re:Invent"
    },
    # Gas2 : {
    #   name             = "Gas2"
    #   short_name       = "G2"
    #   computer_module  = "ESP32"
    #   manufacturer     = "M5Stack"
    #   model            = "M5StickC-Plus"
    #   device           = "Gas Sensor"
    #   registered_owner = "Lee Jeknis" // Your Name
    #   primary_location = "re:Invent"
    # },

  }

  # - Cognito -
  # Admin Users to create
  mpc_admin_cognito_users = {
    // replace with your desired cognito users
    NarutoUzumaki : {
      username       = "nuzumaki"
      given_name     = "Naruto"
      family_name    = "Uzumaki"
      email          = "nuzumaki@hokage.com"
      email_verified = true // no touchy
    },
    # SasukeUchiha : {
    #   username       = "suchiha"
    #   given_name     = "Sasuke"
    #   family_name    = "Uchiha"
    #   email          = "suchiha@chidori.com"
    #   email_verified = true // no touchy
    # },
  }
  # Standard Users to create
  # mpc_standard_cognito_users = {
  #   // replace with your desired cognito users
  #   DefaultStandardUser : {
  #     username       = "default"
  #     given_name     = "Default"
  #     family_name    = "User"
  #     email          = "default@example.com"
  #     email_verified = true // no touchy
  #   }
  # }
}


