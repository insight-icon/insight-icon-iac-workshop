terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {}

dependency "ec2" {
  config_path = "../../citizen/ec2"
}


inputs = {
  region = "us-east-1"

  p2p_ip = dependency.ec2.outputs.public_ip
}