terraform {
  source = "${local.source}"
}

include {
  path = find_in_parent_folders()
}

locals {
  repo_owner = "insight-infrastructure"
  repo_name = "terraform-aws-icon-p-rep-node"
  repo_version = "master"
  repo_path = ""

  source = "github.com/${local.repo_owner}/${local.repo_name}.git//${local.repo_path}?ref=${local.repo_version}"

  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account.yaml")}"))
  environment_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("environment.yaml")}"))
  region_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("region.yaml")}"))
}

dependency "vpc" {
  config_path = "../../network/vpc"
}

dependency "sg" {
  config_path = "../sg"
}

dependency "iam" {
  config_path = "../iam"
}

dependency "keys" {
  config_path = "../keys"
}

dependency "user_data" {
  config_path = "../user-data"
}

dependency "user_data" {
  config_path = "../user-data"
}

inputs = {
  name = "prep"

  ebs_volume_size = "{{ cookiecutter.ebs_volume_size }}"
  root_volume_size = 8
  instance_type = "{{ cookiecutter.instance_type }}"
  volume_path = "/dev/sdf"

  subnet_id = dependency.vpc.outputs.public_subnets[0]

  availability_zone = local.region_vars["azs"][0]
  environment = local.environment_vars["environment"]

  user_data = dependency.user_data.outputs.user_data

  key_name = dependency.keys.outputs.key_name
  public_key = dependency.keys.outputs.public_key

  security_groups = [dependency.sg.outputs.this_security_group_id]

  instance_profile_id = dependency.iam.outputs.instance_profile_id

  tags = {
    Network = "TestNet"
  }
}