locals {
  hcloud_token = get_env("TF_VAR_HCLOUD_TOKEN")
}



# this can be set by docker-compose yml using a .env file like `TF_VAR_HCLOUD_TOKEN=`
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    ansible = {
      source  = "ansible/ansible"
    }
  }
}
provider "hcloud" {
  token = "${local.hcloud_token}"
}
provider "ansible" {
}
EOF
}

# remote_state {
#
# }