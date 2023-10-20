resource "hcloud_network" "private" {
  name     = "net_private"
  ip_range = var.private_cidr
}
resource "hcloud_network_subnet" "private" {
  network_id   = hcloud_network.private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.private_cidr
}
resource "hcloud_network_route" "private" {
  network_id  = hcloud_network.private.id
  destination = "0.0.0.0/0"
  gateway     = "${var.private_ip_gw}"
}

resource "hcloud_server_network" "server_private" {
  count     = var.instances_server
  server_id = hcloud_server.server[count.index].id
  subnet_id = hcloud_network_subnet.private.id
  ip = "${var.privet_ip_base_server}${count.index+1}"
}

resource "hcloud_server_network" "agent_private" {
  count     = var.instances_agent
  server_id = hcloud_server.agent[count.index].id
  subnet_id = hcloud_network_subnet.private.id
  ip = "${var.private_ip_base_agent}${count.index+1}"
}