variable "hcloud_token" {
  sensitive = true
  # default = <your-api-token>
}
variable "sudo_user" {
  default = "kup"
}
variable "authorized_key" {
  default = "~/.ssh/id_ed25519.pub"
}

variable "locations" {
  default = ["nbg1", "fsn1", "hel1"]
}

variable "os_type" {
  default = "debian-12"
}

# instances
variable "instances_server" {
  default = "1"
}
variable "prefix_server" {
  default = "blue"
}
variable "server_type_server" {
  default = "cpx11"
}

variable "instances_agent" {
  default = "1"
}
variable "prefix_server" {
  default = "red"
}
variable "server_type_agent" {
  default = "cpx11"
}

# networking
variable "private_cidr" {
  default = "10.1.0.0/16"
}
variable "privet_ip_base_server" {
  default = "10.1.1."
}
variable "private_ip_base_agent" {
  default = "10.1.2."
}
