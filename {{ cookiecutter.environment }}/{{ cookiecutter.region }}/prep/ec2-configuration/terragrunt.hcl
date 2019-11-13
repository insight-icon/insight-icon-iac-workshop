terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "terraform-aws-icon-node-configuration"
  repo_version = "v0.4.0"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"

  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account.yaml")}"))
  environment_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("environment.yaml")}"))
}

dependency "eip" {
  config_path = "../../eip/eip-main"
}

inputs = {
  name = "p-rep-node-configuration"
  eip = dependency.eip.outputs.public_ip

  config_user = "ubuntu"

  environment = local.environment_vars["environment"]

//  config_private_key = local.account_vars["local_private_key"]

  config_playbook_file = "${get_parent_terragrunt_dir()}/configuration-playbooks/p-rep-config/configure.yml"
  config_playbook_roles_dir = "${get_parent_terragrunt_dir()}/configuration-playbooks/p-rep-config/roles"

  playbook_vars = {
    "keystore_path" : local.account_vars["keystore_path"]
    "keystore_password": local.account_vars["keystore_password"]
  }

  //TODO: Will fix this if I need to provide tags
  tags = {}
}
