variable "vnet_name" {
  type    = string
}

variable "azure_region" {
  type    = string
}

variable "instance_template_data" {
    type  = map(string)
}

variable "azure_az" {
  type    = string
}

variable "vnet_cidr_block" {
  type    = string
}

variable "vnet_subnet_cidr_block" {
  type    = string
}

variable "custom_tags" {
  type    = map(string)
  default = {}
}

variable "ssh_public_key" {
  type    = string
}

variable "azure_instance_script_file_name" {
  type    = string
  default = "instance_custom_data.sh"
}

variable "azure_instance_script_template_file_name" {
  type    = string
  default = "instance_custom_data.tftpl"
}
