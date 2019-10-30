terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v3.1.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  name = "services-sg"
  description = "Security group for support cluster only allowing http(s) / ssh access from bastion"

  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account.yaml")}"))

  coporate_ip = local.account_vars["corporate_ip"]
}

dependency "vpc" {
  config_path = "../../network/vpc"
}

inputs = {
  name = local.name

  description = local.description
  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port = 9000
      to_port = 9000
      protocol = "tcp"
      description = "REST API traffic ingress"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "ssh ingress"
      cidr_blocks = "${local.coporate_ip}/32"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 65535
      protocol = -1
      description = "Egress access open to all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {}
}