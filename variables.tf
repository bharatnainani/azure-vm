variable "region" {
  type    = string
  default = "East US"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "virtual_machine_scale_set_name" {
  type    = string
  default = "test-virtual-set"

}

variable "admin_username" {
  type      = string
  default   = "adminuser"
  sensitive = true

}

variable "admin_password" {
  type      = string
  default   = "P@ssw0rd1234!"
  sensitive = true
}