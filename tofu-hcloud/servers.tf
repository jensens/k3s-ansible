resource "hcloud_placement_group" "default" {
  name = "default"
  type = "spread"
}
resource "hcloud_server" "server" {
  count              = var.instances_server
  name               = "${var.prefix_server}-${count.index + 1}"
  image              = var.os_type
  server_type        = var.server_type_server
  location           = var.locations[(count.index + 1) % length(var.locations)]
  ssh_keys           = [hcloud_ssh_key.default.id]
  placement_group_id = hcloud_placement_group.default.id
  labels = {
    type = "net-ipv6"
    type = count.index < var.floating_ips ? "net-ipv4" : ""
    tf-role = "server"
  }
  public_net {
    ipv6_enabled = true
    ipv4_enabled = count.index < var.floating_ips ? true : false
  }
  user_data = templatefile(
    "user-data.yaml.tpl",
    {
      ssh_pubkey = file(var.authorized_key),
      sudo_user  = var.sudo_user,
      floating_ip = count.index < var.floating_ips ? hcloud_floating_ip.four[count.index].ip_address : "",
    }
  )
}

resource "hcloud_server" "agent" {
  count              = var.instances_agent
  name               = "${var.prefix_agent}-${count.index + 1}"
  image              = var.os_type
  server_type        = var.server_type_agent
  location           = var.locations[(count.index + 1) % length(var.locations)]
  ssh_keys           = [hcloud_ssh_key.default.id]
  placement_group_id = hcloud_placement_group.default.id
  public_net {
    ipv6_enabled = true
    ipv4_enabled = false
  }
  labels = {
    type = "net-ipv6"
    tf-role = "agent"
  }
  user_data = templatefile(
    "user-data.yaml.tpl",
    {
      ssh_pubkey = file(var.authorized_key),
      sudo_user  = var.sudo_user,
      floating_ip = "",
    }
  )
}
