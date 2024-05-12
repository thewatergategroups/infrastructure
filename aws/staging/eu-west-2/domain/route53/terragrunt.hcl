// include "root" {
//   path = find_in_parent_folders()
// }
// include "envcommon" {
//   path   = "${dirname(find_in_parent_folders())}/_envcommon/route53.hcl"
//   expose = true
// }

// terraform {
//   source = "${include.envcommon.locals.base_source_url}//?version=${include.envcommon.locals.base_version}"
// }

// locals {
//   account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
//   account_id   = local.account_vars.locals.account_id
//   region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
//   region       = local.region_vars.locals.region
// }

// inputs = {
//   parent_zone_name = "thewatergates-v1.com"
//   parent_zone_record_enabled = false
//   zone_name        = "thewatergategroups-v1.com"
// }
