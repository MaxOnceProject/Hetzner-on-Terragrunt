# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server

resource "hcloud_server" "gitlab" {
  name = "gitlab"
  image = "debian-12"
  server_type = "cx22"  # https://docs.hetzner.com/cloud/servers/overview/
  public_net {
    ipv4_enabled = true
  }

}

resource "null_resource" "ansible_docker" {
  depends_on = [
    hcloud_server.gitlab
  ]

  triggers = {
    id = hcloud_server.gitlab.id
    playbook = filemd5("docker.playbook.yaml")
  }

  connection {
    type = "ssh"
    host = hcloud_server.gitlab.ipv4_address
    user = "root"
    password = var.GITLAB_SERVER_LOGIN
  }

  provisioner "file" {
    source = "docker.playbook.yaml"
    destination = "/tmp/docker.playbook.yaml"
  }

  provisioner "remote-exec" {
    inline = ["apt -y upgrade && apt -y update && apt install -y python3 python3-pip python3-venv",
              "python3 -m venv /tmp/ansible && source /tmp/ansible/bin/activate && pip3 install ansible",
              ". /tmp/ansible/bin/activate",
              "ansible-playbook /tmp/docker.playbook.yaml"]
  }
}

resource "null_resource" "ansible_gitlab" {
  depends_on = [
    hcloud_server.gitlab,
    null_resource.ansible_docker
  ]

  triggers = {
    id = hcloud_server.gitlab.id
    playbook = filemd5("gitlab.playbook.yaml")
  }

  connection {
    type = "ssh"
    host = hcloud_server.gitlab.ipv4_address
    user = "root"
    password = var.GITLAB_SERVER_LOGIN
  }

  provisioner "file" {
    source = "gitlab.playbook.yaml"
    destination = "/tmp/gitlab.playbook.yaml"
  }

  provisioner "remote-exec" {
    inline = [". /tmp/ansible/bin/activate",
              "ansible-playbook /tmp/gitlab.playbook.yaml"]
  }
}