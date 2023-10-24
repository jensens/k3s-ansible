variable "hcloud_token" {
  sensitive = true
  # default = <your-api-token>
}
variable "sudo_user" {
  default = "deployer"
}
variable "authorized_key" {
  default = "~/.ssh/id_ed25519.pub"
}

variable "locations" {
  default = ["fsn1", "hel1", "nbg1"]
}

variable "os_type" {
  default = "debian-12"
}

# instances
variable "instances_server" {
  default = "3"
}
variable "prefix_server" {
  default = "blue"
}
variable "server_type_server" {
  default = "cpx11"
}

variable "instances_agent" {
  default = "2"
}
variable "prefix_agent" {
  default = "red"
}
variable "server_type_agent" {
  default = "cpx11"
}

# networking
variable "floating_ips" {
  # must be equal or less to instances_server
  default = 2
}
variable "private_cidr" {
  default = "10.1.0.0/16"
}
variable "privat_ip_base_server" {
  default = "10.1.1."
}
variable "private_ip_base_agent" {
  default = "10.1.2."
}
