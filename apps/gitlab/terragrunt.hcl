include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "./main.tf"
}

dependency "common" {
  config_path = "../common"
}

inputs = {
  region = dependency.common.outputs.region
  datacenter = dependency.common.outputs.datacenter
}