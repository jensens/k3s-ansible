resource "hcloud_ssh_key" "default" {
  name       = "tf_hetzner_key"
  public_key = file("~/.ssh/tf_hetzner.pub")
}