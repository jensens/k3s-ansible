resource "hcloud_server" "serveripv4" {
  name        = "server-0"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  placement_group_id = hcloud_placement_group.placement-group-k3s.id
  labels = {
    type = "server-router"
  }
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data   = templatefile("user-data.yaml.tpl",
    {ssh_pubkey = file("~/.ssh/tf_hetzner.pub")})

}
resource "hcloud_server" "server" {
  count       = var.instances_server
  name        = "server-${count.index+1}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  placement_group_id = hcloud_placement_group.placement-group-k3s.id
  labels = {
    type = "server-ipv6only"
  }
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
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
  placement_group_id = hcloud_placement_group.placement-group-k3s.id
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
  }
  labels = {
    type = "agent-ipv6only"
  }
  user_data   = templatefile("user-data.yaml.tpl",
    {ssh_pubkey = file("~/.ssh/tf_hetzner.pub")})
}