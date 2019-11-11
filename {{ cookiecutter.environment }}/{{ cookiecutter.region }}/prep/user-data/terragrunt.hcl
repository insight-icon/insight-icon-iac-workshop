terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "terraform-aws-icon-user-data"
  repo_version = "v0.1.0"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"
}

inputs = {
  type = "prep"
  ssh_user = "ubuntu"
  prometheus_enabled = false
  consul_enabled = false
}

