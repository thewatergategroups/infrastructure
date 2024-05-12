include "root" {
  path = find_in_parent_folders()
}
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/iam-system-user.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id   = local.account_vars.locals.account_id
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
}

inputs = {
  name = "tf-lest-encrypt-iam-role-${local.region}"
  inline_policies = [
    jsonencode({
      "Version" : "2012-10-17",
      "Sid": "LetsEncryptAllow",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter",
            "ssm:PutParameter",
            "ssm:DescribeParameter",
          ],
          "Resource" : [
            "arn:aws:ssm:*:${local.account_id}:parameter/*"
          ]
        }
      ]
      }
    )
  ]
}