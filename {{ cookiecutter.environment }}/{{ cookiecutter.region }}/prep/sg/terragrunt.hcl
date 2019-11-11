terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v3.1.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  name = "services-sg"
  description = "Security group for support cluster only allowing http(s) / ssh access from bastion"

  corporate_ip = chomp(run_cmd("curl", "http://ifconfig.co"))
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
      from_port = 7100
      to_port = 7100
      protocol = "tcp"
      description = "grpc traffic ingress"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 9000
      to_port = 9000
      protocol = "tcp"
      description = "json rpc traffic ingress"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "ssh ingress"
      cidr_blocks = format("%s/%s", local.corporate_ip, "32")
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