variable "apic_user" {
  type = string
}

variable "apic_password" {
  type = string
}

variable "apic_ip" {
  type = string
}

variable "tenant_name" {
  type    = string
  default = "ACME-TF-LOCAL"
}

variable "app_profile_name" {
  type    = string
  default = "ACME-ANP"
}

variable "epg_1_name" {
  type    = string
  default = "WEB"
}

variable "epg_2_name" {
  type    = string
  default = "DB"
}

variable "vrf_name" {
  type    = string
  default = "ACME-VRF"
}

variable "bd_name" {
  type    = string
  default = "ACME-BD"
}

variable "bd_subnet_cidr" {
  type    = string
  default = "1.1.1.1/24"
}