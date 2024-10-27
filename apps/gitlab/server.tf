# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server

resource "hcloud_server" "gitlab" {
  name        = "gitlab"
  image       = "debian-12"
  server_type = "cx22"  # https://docs.hetzner.com/cloud/servers/overview/
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}