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
  gateway     = "${var.privat_ip_base_server}1"
}

resource "hcloud_server_network" "server_private" {
  count     = var.instances_server
  server_id = hcloud_server.server[count.index].id
  subnet_id = hcloud_network_subnet.private.id
  ip        = "${var.privat_ip_base_server}${count.index + 1}"
}

resource "hcloud_server_network" "agent_private" {
  count     = var.instances_agent
  server_id = hcloud_server.agent[count.index].id
  subnet_id = hcloud_network_subnet.private.id
  ip        = "${var.private_ip_base_agent}${count.index + 1}"
}
resource "hcloud_floating_ip" "four" {
  count         = var.floating_ips
  name          = "ipv4-${count.index + 1}"
  type          = "ipv4"
  home_location = var.locations[(count.index + 1) % length(var.locations)]
  # lifecycle {
  #     prevent_destroy = true
  # }
}
resource "hcloud_floating_ip" "six" {
  count         = var.floating_ips
  name          = "ipv6-${count.index + 1}"
  type          = "ipv6"
  home_location = var.locations[(count.index + 1) % length(var.locations)]
  # lifecycle {
  #     prevent_destroy = true
  # }
}
resource "hcloud_floating_ip_assignment" "four" {
  count          = var.floating_ips
  floating_ip_id = hcloud_floating_ip.four[count.index].id
  server_id      = hcloud_server.server[count.index].id
}
resource "hcloud_floating_ip_assignment" "six" {
  count          = var.floating_ips
  floating_ip_id = hcloud_floating_ip.six[count.index].id
  server_id      = hcloud_server.server[count.index].id
}