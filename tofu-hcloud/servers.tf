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
  public_net {
    ipv6_enabled = true
    ipv4_enabled = count.index < var.floating_ips ? true : false
  }
  labels = {
    "tofu/ipv6" = "public"
    "tofu/ipv4" = count.index < var.floating_ips ? "public" : "private"
    "tofu/natgw" = count.index == 0 ? "true" : "false"
    "tofu/role" = "server"
  }
  user_data = templatefile(
    "user-data.yaml.tpl",
    {
      ssh_pubkey = file(var.authorized_key),
      sudo_user  = var.sudo_user,
      floating_ipv4 = count.index < var.floating_ips ? hcloud_floating_ip.four[count.index].ip_address : "",
      floating_ipv6 = count.index < var.floating_ips ? hcloud_floating_ip.six[count.index].ip_address : "",
      nat = count.index == 0,
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
    "tofu/ipv6" = "public"
    "tofu/ipv4" = "private"
    "tofu/role" = "agent"
  }
  user_data = templatefile(
    "user-data.yaml.tpl",
    {
      ssh_pubkey = file(var.authorized_key),
      sudo_user  = var.sudo_user,
      floating_ipv4 = "",
      floating_ipv6 = "",
      nat = false,
    }
  )
}
