terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.44.1"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token   = var.hcloud_token
}

## SSH
resource "hcloud_ssh_key" "default" {
  name       = "tf_hetzner_key"
  public_key = file(var.authorized_key)
}
