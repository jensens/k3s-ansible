resource "hcloud_network" "k3s_private" {
  name     = "k3s_net_private"
  ip_range = var.ip_range
}

resource "hcloud_network_subnet" "k3s_priv_subnet" {
  network_id   = hcloud_network.k3s_private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.ip_range
}

resource "hcloud_server_network" "k3s_server_network" {
  count     = var.instances_server
  server_id = hcloud_server.server[count.index].id
  subnet_id = hcloud_network_subnet.k3s_priv_subnet.id
}

resource "hcloud_server_network" "k3s_agent_network" {
  count     = var.instances_agent
  server_id = hcloud_server.agent[count.index].id
  subnet_id = hcloud_network_subnet.k3s_priv_subnet.id
}
