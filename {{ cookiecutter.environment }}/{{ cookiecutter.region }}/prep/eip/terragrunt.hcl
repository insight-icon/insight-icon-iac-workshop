terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

dependency "ec2" {
  config_path = "../../prep/ec2"
}

inputs = {
  name = "main"

  instance_id = dependency.ec2.outputs.instance_id
}

