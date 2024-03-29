terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v2.15.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  name = "vpc"
}

inputs = {
  enable_nat_gateway = "false"
  name = "main-net-vpc"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  cidr = "10.0.0.0/16"

  azs = ["{{ cookiecutter.region }}a"]

  private_subnets = [
    "10.0.0.0/24"]
  public_subnets = [
    "10.0.3.0/24"]
}

