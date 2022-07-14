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
resource "hcloud_network_route" "k3s_nat" {
  network_id  = hcloud_network.k3s_private.id
  destination = "0.0.0.0/0"
  gateway     = "${var.ip_base}2"
}
resource "hcloud_server_network" "k3s_serveripv4_network" {
  server_id = hcloud_server.serveripv4.id
  subnet_id = hcloud_network_subnet.k3s_priv_subnet.id
  ip = "${var.ip_base}2"
}
resource "hcloud_server_network" "k3s_server_network" {
  count     = var.instances_server
  server_id = hcloud_server.server[count.index].id
  subnet_id = hcloud_network_subnet.k3s_priv_subnet.id
  ip = "${var.ip_base}${3+count.index}"
}

resource "hcloud_server_network" "k3s_agent_network" {
  count     = var.instances_agent
  server_id = hcloud_server.agent[count.index].id
  subnet_id = hcloud_network_subnet.k3s_priv_subnet.id
  ip = "${var.ip_base}${100+count.index}"
}
