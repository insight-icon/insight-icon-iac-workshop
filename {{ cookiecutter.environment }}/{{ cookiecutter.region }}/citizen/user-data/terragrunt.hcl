terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "terraform-aws-icon-user-data"
  repo_version = "master"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"
}

inputs = {
  type = "citizen"
  ssh_user = "ubuntu"
  prometheus_enabled = false
  consul_enabled = false
}

