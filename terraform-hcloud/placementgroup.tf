resource "hcloud_placement_group" "placement-group-k3s" {
  name = "placement-group-k3s"
  type = "spread"
}
