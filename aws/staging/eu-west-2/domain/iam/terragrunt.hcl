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
  hostedzone = {
    id = "Z061744026X1CUF71V2PH"
  }
}

inputs = {
  name = "tf-iam-user-domain-management"
  inline_policies = [
    jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "route53:ListHostedZones",
              "route53:GetChange",
              "route53:ListHostedZonesByName"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "route53:ListResourceRecordSets",
              "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
              "arn:aws:route53:::hostedzone/${local.hostedzone.id}"
            ]
          }
        ]
      }
    )
  ]
}
