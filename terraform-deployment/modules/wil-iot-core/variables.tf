# General
variable "project_prefix" {
  type        = string
  default     = null
  description = "The prefix appended to relevant names for resources deployed. Ex. mpc-api, mpc_web_app, etc."

}

# SSM
variable "lookup_existing_general_ssm_parameters" {
  type    = bool
  default = false
}
variable "lookup_existing_minipuppers_ssm_parameters" {
  type    = bool
  default = false
}



# - Amplify -
variable "create_amplify_app" {
  type        = bool
  default     = false
  description = "Conditional creation of AWS Amplify Web Application"
}
variable "app_name" {
  type        = string
  default     = "mpc-App"
  description = "The name of the Amplify Application"
}
variable "enable_auto_branch_creation" {
  type        = bool
  default     = true
  description = "Enables automated branch creation for the Amplify app"

}
variable "enable_auto_branch_deletion" {
  type        = bool
  default     = true
  description = "Automatically disconnects a branch in the Amplify Console when you delete a branch from your Git repository"

}
variable "auto_branch_creation_patterns" {
  type        = list(any)
  default     = ["main", "dev", ]
  description = "Automated branch creation glob patterns for the Amplify app. Ex. feat*/*"

}
variable "enable_auto_build" {
  type        = bool
  default     = true
  description = "Enables auto-building of autocreated branches for the Amplify App."

}
variable "enable_amplify_app_pr_preview" {
  type        = bool
  default     = false
  description = "Enables pull request previews for the autocreated branch"

}
variable "enable_performance_mode" {
  type        = bool
  default     = false
  description = "Enables performance mode for the branch. This keeps cache at Edge Locations for up to 10min after changes"
}
variable "framework" {
  type        = string
  default     = "React"
  description = "Framework for the autocreated branch"

}
variable "existing_repo_url" {
  type        = string
  default     = null
  description = "URL for the existing repo"

}

variable "amplify_app_framework" {
  type    = string
  default = "React"

}
variable "create_amplify_domain_association" {
  type    = bool
  default = false

}
variable "amplify_app_domain_name" {
  type        = string
  default     = "example.com"
  description = "The name of your domain. Ex. naruto.ninja"

}


# CodeCommit
variable "create_codecommit_repo" {
  type    = bool
  default = false
}
variable "codecommit_repo_name" {
  type    = string
  default = null
}
variable "codecommit_repo_description" {
  type    = string
  default = "The CodeCommit repo created in the Terraform deployment"
}
variable "codecommit_repo_default_branch" {
  type    = string
  default = "main"

}


# GitHub
variable "lookup_ssm_github_access_token" {
  type        = bool
  default     = false
  description = <<-EOF
  *ImpcORTANT!*
  Conditional data fetch of SSM parameter store for GitHub access token.
  To ensure security of this token, you must manually add it via the AWS console
  before using.
  EOF

}

variable "github_access_token" {
  type        = string
  default     = null
  description = "Optional GitHub access token. Only required if using GitHub repo."

}

variable "ssm_github_access_token_name" {
  type        = string
  default     = null
  description = "The name (key) of the SSM parameter store of your GitHub access token"

}


# GitLab Mirroring
variable "enable_gitlab_mirroring" {
  type        = bool
  default     = false
  description = "Enables GitLab mirroring to the option AWS CodeCommit repo."
}
variable "gitlab_mirroring_iam_user_name" {
  type        = string
  default     = "gitlab_mirroring"
  description = "The IAM Username for the GitLab Mirroring IAM User."
}
variable "gitlab_mirroring_policy_name" {
  type        = string
  default     = "gitlab_mirroring_policy"
  description = "The name of the IAM policy attached to the GitLab Mirroring IAM User"
}


# AppSync - GraphQL
variable "create_graphql_api" {
  type        = bool
  default     = false
  description = "Conditional creation of GraphQL API and related resources"

}
variable "appsync_graphql_api_name" {
  type    = string
  default = "wil-graphql-api"

}


# - IAM -

variable "create_restricted_access_roles" {
  type        = bool
  default     = true
  description = "Conditional creation of restricted access roles"

}


# - DynamoDB -
variable "dynamodb_ttl_enable" {
  type    = bool
  default = false
}
variable "dynamodb_ttl_attribute" {
  type    = string
  default = "TimeToExist"
}
variable "devices_billing_mode" {
  type    = string
  default = "PROVISIONED"
}
variable "devices_read_capacity" {
  type    = number
  default = 20

}
variable "devices_write_capacity" {
  type    = number
  default = 20

}


# - Cognito -
# User Pool
variable "user_pool_name" {
  type        = string
  default     = "wil_user_pool"
  description = "The name of the Cognito User Pool created"
}
variable "user_pool_client_name" {
  type        = string
  default     = "wil_user_pool_client"
  description = "The name of the Cognito User Pool Client created"
}
variable "identity_pool_name" {
  type        = string
  default     = "identity_pool"
  description = "The name of the Cognito Identity Pool created"

}
variable "identity_pool_allow_unauthenticated_identites" {
  type    = bool
  default = false
}
variable "identity_pool_allow_classic_flow" {
  type    = bool
  default = false

}
variable "email_verification_message" {
  type        = string
  default     = <<-EOF

  Thank you for registering with the Mini Pupper Control App. This is your email confirmation.
  Verification Code: {####}

  EOF
  description = "The Cognito email verification message"
}
variable "email_verification_subject" {
  type        = string
  default     = "wil App Verification"
  description = "The Cognito email verification subject"
}
variable "invite_email_message" {
  type    = string
  default = <<-EOF
    You have been invited to the Mini Pupper Control App! Your username is "{username}" and
    tempcorary password is "{####}". Please reach out to an admin if you have issues signing in.

  EOF

}
variable "invite_email_subject" {
  type    = string
  default = <<-EOF
  Welcome to Mini Pupper Control!
  EOF

}
variable "invite_sms_message" {
  type    = string
  default = <<-EOF
    You have been invited to the Mini Pupper Control App! Your username is "{username}" and
    tempcorary password is "{####}".

  EOF

}
variable "password_policy_min_length" {
  type        = number
  default     = 8
  description = "The minimum nmber of characters for Cognito user passwords"
}
variable "password_policy_require_lowercase" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 lowercase character"

}
variable "password_policy_require_uppercase" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 uppercase character"

}
variable "password_policy_require_numbers" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 number"

}

variable "password_policy_require_symbols" {
  type        = bool
  default     = true
  description = "Whether or not the Cognito user password must have at least 1 special character"

}

variable "password_policy_temp_password_validity_days" {
  type        = number
  default     = 7
  description = "The number of days a tempc password is valid. If user does not sign-in during this time, will need to be reset by an admin"

}
# General Schema
variable "schemas" {
  description = "A container with the schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default     = []
}
# Schema (String)
variable "string_schemas" {
  description = "A container with the string schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default = [{
    name                     = "email"
    attribute_data_type      = "String"
    required                 = true
    mutable                  = false
    developer_only_attribute = false

    string_attribute_constraints = {
      min_length = 7
      max_length = 60
    }
    },
    {
      name                     = "given_name"
      attribute_data_type      = "String"
      required                 = true
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 25
      }
    },
    {
      name                     = "family_name"
      attribute_data_type      = "String"
      required                 = true
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 25
      }
    },
    {
      name                     = "IAC_PROVIDER"
      attribute_data_type      = "String"
      required                 = false
      mutable                  = true
      developer_only_attribute = false

      string_attribute_constraints = {
        min_length = 1
        max_length = 10
      }
    },
  ]
}
# Schema (number)
variable "number_schemas" {
  description = "A container with the number schema attributes of a user pool. Maximum of 50 attributes"
  type        = list(any)
  default     = []
}

# Admin Users
variable "admin_cognito_users" {
  type    = map(any)
  default = {}
}

variable "admin_cognito_user_group_name" {
  type    = string
  default = "Admin"

}
variable "admin_cognito_user_group_description" {
  type    = string
  default = "Admin Group"

}
# Standard Users
variable "standard_cognito_users" {
  type    = map(any)
  default = {}

}
variable "standard_cognito_user_group_name" {
  type    = string
  default = "Standard"

}
variable "standard_cognito_user_group_description" {
  type    = string
  default = "Standard Group"

}

# - IoT Core -
# IoT Things
variable "wil_climate_sensor_arrays" {
  type    = map(any)
  default = {}
}
variable "wil_flow_sensor_arrays" {
  type    = map(any)
  default = {}
}
variable "create_wil_climate_sensor_array_fleet_iot_thing_group" {
  type    = bool
  default = true

}
variable "create_wil_flow_sensor_array_fleet_iot_thing_group" {
  type    = bool
  default = true

}
variable "create_greengrass_component" {
  type    = bool
  default = false

}
variable "create_greengrass_deployment" {
  type    = bool
  default = false
}

# - WiFi Information -
variable "wifi_ssid" {
  type        = string
  default     = ""
  description = "The SSID for the primary local network you want your IoT device to connect to."
  sensitive   = true

}
variable "wifi_password" {
  type        = string
  default     = ""
  description = "The password for the primary local network you want your IoT device to connect to."
  sensitive   = true

}


# Tagging
variable "tags" {
  type        = map(any)
  description = "Tags to apply to resources"
  default = {
    "IAC_PROVIDER" = "Terraform"
  }
}


