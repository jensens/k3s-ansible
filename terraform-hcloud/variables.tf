variable "hcloud_token" {
  sensitive = true
  # default = <your-api-token>
}

variable "location" {
  default = "nbg1"
}

variable "instances_server" {
  default = "2"
}
variable "instances_agent" {
  default = "2"
}

variable "server_type" {
  default = "cx11"
}

variable "os_type" {
  default = "debian-11"
}

variable "ip_range" {
  default = "10.0.10.0/24"
}
variable "ip_base" {
  default = "10.0.10."
}
