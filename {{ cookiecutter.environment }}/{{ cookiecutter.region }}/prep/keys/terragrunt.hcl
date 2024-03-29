terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "terraform-aws-icon-p-rep-keys"
  repo_version = "v0.3.0"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"

  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account.yaml")}"))
  environment_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("environment.yaml")}"))
}

inputs = {
  name = "prep-1"
//  local_public_key = local.account_vars["local_public_key"]

  environment = local.environment_vars["environment"]
  tags = {}
}
