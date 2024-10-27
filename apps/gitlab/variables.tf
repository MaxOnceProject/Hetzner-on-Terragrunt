# output global locals

variable "region" {
  type = string
}

variable "datacenter" {
  type = string
}

# this is required for provisioning and can be set in .env like `TV_VAR_GITLAB_SERVER_LOGIN=`
variable "GITLAB_SERVER_LOGIN" {
  type = string
}