resource "hcloud_server" "server" {
  count       = var.instances_server
  name        = "server-${count.index}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "server"
  }
  user_data   = templatefile("user-data.yaml.tpl",
    {ssh_pubkey = file("~/.ssh/tf_hetzner.pub")})
}
resource "hcloud_server" "agent" {
  count       = var.instances_agent
  name        = "agent-${count.index}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "agent"
  }
  user_data   = templatefile("user-data.yaml.tpl",
    {ssh_pubkey = file("~/.ssh/tf_hetzner.pub")})
}