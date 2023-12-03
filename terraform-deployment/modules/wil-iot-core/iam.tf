# TODO - Add descriptions to all Roles, and Policies
# --- TRUST RELATIONSHIPS ---
# Cognito Trust Relationship (AuthRole)
data "aws_iam_policy_document" "cognito_authrole_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
  }
}
# Cognito Trust Relationship (UnauthRole)
data "aws_iam_policy_document" "cognito_unauthrole_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
  }
}
# Cognito Admin Group Trust Relationship
data "aws_iam_policy_document" "cognito_admin_group_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
  }
}
# Cognito Standard Group Trust Relationship
data "aws_iam_policy_document" "cognito_standard_group_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.identity_pool.id]
    }
  }
}
# AppSync Trust Relationship
data "aws_iam_policy_document" "appsync_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}
# Amplify Trust Relationship
data "aws_iam_policy_document" "amplify_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}
# IoT Trust Relationship
data "aws_iam_policy_document" "iot_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["iot.amazonaws.com"]
    }
  }
}


# NEW
# IoT CredentialsTrust Relationship
data "aws_iam_policy_document" "iot_credentials_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["credentials.iot.amazonaws.com"]
    }
  }
}



# --- CUSTOMER MANAGED POLICIES (RESTRICTED ACCESS) ---
# - IoT Policies -
# Policy to allow AWS IoT Rule to PutItem in MQTT DynamoDB Table
data "aws_iam_policy_document" "iot_to_timestream_restricted_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["timestream:*"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContextKeys"
      values   = ["aws:timestream:database-name"]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["timestream.*.amazonaws.com"]
    }
  }
}
resource "aws_iam_policy" "iot_to_timestream_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_iot_to_timestream_restricted_access_policy"
  description = "Policy granting AmazonTimestreamFullAccess permissions."
  policy      = data.aws_iam_policy_document.iot_to_timestream_restricted_access_policy.json
}


# # Policy to allow AWS IoT Rule to PutItem in MQTT DynamoDB Table
# data "aws_iam_policy_document" "iot_to_dynamodb_restricted_access_policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["dynamodb:PutItem"]
#     resources = [aws_dynamodb_table.iot_devices_mqtt.arn]
#   }
# }
# resource "aws_iam_policy" "iot_to_dynamodb_restricted_access_policy" {
#   count       = var.create_restricted_access_roles ? 1 : 0
#   name        = "${var.project_prefix}_iot_to_dynamodb_restricted_access_policy"
#   description = "Policy granting DynamoDB 'PutItem' access for the iot_devices_mqtt DynamoDB table."
#   policy      = data.aws_iam_policy_document.iot_to_dynamodb_restricted_access_policy.json
# }




# NEW
# Policy to allow for GreenGrassV2TokenExchange FIRST
data "aws_iam_policy_document" "greengrass_v2_token_exchange" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation",
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "greengrass_v2_token_exchange_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_GreengrassV2TokenExchangeRoleAccess"
  description = "First Policy for GreengrassV2TokenExchangeRole."
  policy      = data.aws_iam_policy_document.greengrass_v2_token_exchange.json
}
# Policy to allow for GreenGrassV2TokenExchange SECOND
data "aws_iam_policy_document" "greengrass_v2_token_exchange_2" {
  statement {
    effect = "Allow"
    actions = [
      "iot:DescribeCertificate",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Publish",
      "iot:Receive",
      "iot:RetainPublish"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/device/MiniPupper_2/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Subscribe"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topicfilter/device/MiniPupper_2/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iot:Connect"
    ]
    resources = ["arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:client/CLIENTID"]
  }
}
resource "aws_iam_policy" "greengrass_v2_token_exchange_restricted_access_policy_2" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_GreengrassV2TokenExchangeRoleAccess_2"
  description = "Seoncd Policy for GreengrassV2TokenExchangeRole."
  policy      = data.aws_iam_policy_document.greengrass_v2_token_exchange_2.json
}
# Policy for Greengrass S3
data "aws_iam_policy_document" "greengrass_s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "${aws_s3_bucket.greengrass_s3_bucket.arn}",
      "${aws_s3_bucket.greengrass_s3_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.greengrass_s3_bucket.arn}",
      "${aws_s3_bucket.greengrass_s3_bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["greengrass:*"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["iot:*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "greengrass_s3_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_GreengrassS3Policy"
  description = "Policy for Greengrass S3."
  policy      = data.aws_iam_policy_document.greengrass_s3.json
}






# - DynamoDB Policies -
# DynamoDB Customer Managed Policy (All Actions)
data "aws_iam_policy_document" "dynamodb_restricted_access_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      # "${aws_dynamodb_table.iot_devices.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "dynamodb_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_dynamodb_restricted_access_policy"
  description = "Policy granting full DynamoDB permissions for the iot_devices DynamoDB table."
  policy      = data.aws_iam_policy_document.dynamodb_restricted_access_policy[0].json

}

data "aws_iam_policy_document" "mqtt_dynamodb_restricted_access_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]
    resources = [
      # "${aws_dynamodb_table.iot_devices_mqtt.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "mqtt_dynamodb_restricted_access_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_mqtt_dynamodb_restricted_access_policy"
  description = "Policy granting full DynamoDB permissions for the iot_devices_mqtt DynamoDB table."
  policy      = data.aws_iam_policy_document.mqtt_dynamodb_restricted_access_policy[0].json

}

# DynamoDB Customer Managed Policy (Read Only Actions)
data "aws_iam_policy_document" "dynamodb_restricted_access_read_only_policy" {
  count = var.create_restricted_access_roles ? 1 : 0
  # description = "Policy granting full DynamoDB permissions for the iot_devices DynamoDB table."
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
    ]
    resources = [
      # "${aws_dynamodb_table.iot_devices.arn}",
      "*",
    ]
  }
}
resource "aws_iam_policy" "dynamodb_restricted_access_read_only_policy" {
  count       = var.create_restricted_access_roles ? 1 : 0
  name        = "${var.project_prefix}_dynamodb_restricted_access_read_only_policy"
  description = "Policy granting restricted (read-only) DynamoDB permissions for the iot_devices DynamoDB table."
  policy      = data.aws_iam_policy_document.dynamodb_restricted_access_read_only_policy[0].json

}

# --- IAM ROLES ---
# - Cognito Roles -
# Cognito AuthRole Restricted Access
# Role granting restricted access permissions to Cognito authenticated users
resource "aws_iam_role" "cognito_authrole_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "${var.project_prefix}_authRole_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.cognito_authrole_trust_relationship.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSIoTConfigAccess",
    "arn:aws:iam::aws:policy/AWSIoTDataAccess",
    # aws_iam_policy.s3_restricted_access_policy[0].arn,
    # aws_iam_policy.ssm_restricted_access_policy[0].arn,
    # aws_iam_policy.iot_restricted_access_policy[0].arn,
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}
# Cognito UnAuth Role
# Role granting restricted access permissions to Cognito authenticated users
resource "aws_iam_role" "cognito_unauthrole_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "${var.project_prefix}_unauthRole_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.cognito_unauthrole_trust_relationship.json

  # Managed Policies
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

# Cognito Admin Group Role (Restricted Access)
resource "aws_iam_role" "cognito_admin_group_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "${var.project_prefix}_cognito_admin_group_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.cognito_admin_group_trust_relationship.json
  description        = "Role granting full DynamoDB permissions for the iot_devicess DynamoDB table."
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AWSIoTConfigAccess",
    "arn:aws:iam::aws:policy/AWSIoTDataAccess",
    # aws_iam_policy.s3_restricted_access_policy[0].arn,
    aws_iam_policy.dynamodb_restricted_access_policy[0].arn,
    aws_iam_policy.mqtt_dynamodb_restricted_access_policy[0].arn,
    # aws_iam_policy.iot_restricted_access_policy[0].arn,
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

# Cognito Standard Group Role (Restricted Access)
resource "aws_iam_role" "cognito_standard_group_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count = var.create_restricted_access_roles ? 1 : 0

  name               = "${var.project_prefix}_cognito_standard_group_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.cognito_standard_group_trust_relationship.json
  description        = "Role granting restricted (read-only) DynamoDB permissions for the iot_devicess DynamoDB table."
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    aws_iam_policy.dynamodb_restricted_access_read_only_policy[0].arn
  ]
  max_session_duration  = "43200" // duration in seconds
  force_detach_policies = true
  path                  = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}

# - AppSync Roles -
# AppSync Restricted Access Role
# Role granting AppSync DynamoDB restricted access, SSM restricted read-only access, and the ablity to access to CloudWatch Logs.
resource "aws_iam_role" "appsync_dynamodb_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "${var.project_prefix}_appsync_dynamodb_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.appsync_trust_relationship.json
  # Managed Policies
  managed_policy_arns = [
    aws_iam_policy.dynamodb_restricted_access_policy[0].arn,
    aws_iam_policy.mqtt_dynamodb_restricted_access_policy[0].arn,
    # aws_iam_policy.ssm_restricted_access_policy[0].arn,
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
  force_detach_policies = true
  path                  = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}


# - IoT Roles -
# IoT Restricted Access Role
# Role granting IoT access to timestream.
resource "aws_iam_role" "iot_to_timestream_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "${var.project_prefix}_iot_to_timestream_restricted_access"
  assume_role_policy = data.aws_iam_policy_document.iot_trust_relationship.json
  managed_policy_arns = [
    aws_iam_policy.iot_to_timestream_restricted_access_policy[0].arn
  ]
}

# # Role granting IoT DynamoDB restricted access (PutItem).
# resource "aws_iam_role" "iot_to_dynamodb_restricted_access" {
#   # Conditional create of the role - default is 'TRUE'
#   count              = var.create_restricted_access_roles ? 1 : 0
#   name               = "${var.project_prefix}_iot_to_dynamodb_restricted_access"
#   assume_role_policy = data.aws_iam_policy_document.iot_trust_relationship.json
#   managed_policy_arns = [
#     aws_iam_policy.iot_to_dynamodb_restricted_access_policy[0].arn
#   ]
# }


# NEW
# GreengrassV2TokenExchangeRole
resource "aws_iam_role" "iot_token_exchange_role_restricted_access" {
  # Conditional create of the role - default is 'TRUE'
  count              = var.create_restricted_access_roles ? 1 : 0
  name               = "${var.project_prefix}_GreengrassV2TokenExchangeRole"
  assume_role_policy = data.aws_iam_policy_document.iot_credentials_trust_relationship.json
  managed_policy_arns = [
    aws_iam_policy.greengrass_v2_token_exchange_restricted_access_policy[0].arn,
    aws_iam_policy.greengrass_v2_token_exchange_restricted_access_policy_2[0].arn,
    aws_iam_policy.greengrass_s3_restricted_access_policy[0].arn,
  ]
}


# Amplify

resource "aws_iam_role" "amplify_codecommit" {
  count               = var.create_codecommit_repo ? 1 : 0
  name                = "${var.project_prefix}_amplify_codecommit"
  assume_role_policy  = data.aws_iam_policy_document.amplify_trust_relationship.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}

# GitLab
resource "aws_iam_user" "gitlab_mirroring" {
  count         = var.enable_gitlab_mirroring ? 1 : 0
  name          = var.gitlab_mirroring_iam_user_name
  path          = "/${var.app_name != null ? var.app_name : "${var.project_prefix}_app"}/"
  force_destroy = true // prevents DeleteConflict Error

  tags = merge(
    {
      "AppName" = var.app_name != null ? var.app_name : "${var.project_prefix}_app"
    },
    var.tags,
  )
}
resource "aws_iam_user_policy" "gitlab_mirroring_policy" {
  count = var.enable_gitlab_mirroring ? 1 : 0
  name  = var.gitlab_mirroring_policy_name
  user  = aws_iam_user.gitlab_mirroring[0].name


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "MinimumGitLabMirroringPermissions"
      Action = ["codecommit:GitPull", "codecommit:GitPush"]
      Effect = "Allow"
      Resource = [
        "${aws_codecommit_repository.codecommit_repo[0].arn}"
      ]
    }]

  })

}







