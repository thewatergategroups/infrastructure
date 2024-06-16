include "root" {
  path = find_in_parent_folders()
}
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/iam-system-user.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}//?version=${include.envcommon.locals.base_version}"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id   = local.account_vars.locals.account_id
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
}

inputs = {
  name = "resource-manager-${local.account_id}"
  inline_policies = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter",
            "ssm:PutParameter",
            "ssm:GetParametersByPath",
            "ssm:DeleteParameter"
          ],
          "Resource" : [
            "arn:aws:ssm:${local.region}:${local.account_id}:parameter/apps",
            "arn:aws:ssm:${local.region}:${local.account_id}:parameter/apps/*"
          ]
        },
        {
          "Action": [
            "ssm:DescribeParameters"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:ssm:${local.region}:${local.account_id}:*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets",
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : "*"
        }
      ]
      }
    )
  ]
}