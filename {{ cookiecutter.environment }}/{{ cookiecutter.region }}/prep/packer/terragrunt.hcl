terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "icon-node-packer-build"
  repo_version = "v0.3.0"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"

  environment_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("environment.yaml")}"))
}

inputs = {
  name = "p-rep"
  distro = "ubuntu-18"
  node = "p-rep"

  environment = local.environment_vars["environment"]
}

