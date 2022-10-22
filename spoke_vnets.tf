module "spoke_vnet_a" {
  source                  = "./spoke_vnets"
  azure_region            = var.azure_region
  azure_az                = "1"
  vnet_name               = "${var.project_prefix}-spoke-vnet-a"
  vnet_cidr_block         = "10.32.16.0/22"
  vnet_subnet_cidr_block  = "10.32.16.0/24"
  instance_template_data  = {
    tailscale_key   = var.tailscale_key,
    tailscale_hostname = format("%s-spoke-vnet-a", var.project_prefix)
  }
  custom_tags             = {
    Name  = "${var.project_prefix}-spoke-vnet-a"
    Owner = var.owner_tag
  }
  ssh_public_key          = var.ssh_public_key
}

module "spoke_vnet_b" {
  source                  = "./spoke_vnets"
  azure_region            = var.azure_region
  azure_az                = "2"
  vnet_name               = "${var.project_prefix}-spoke-vnet-b"
  vnet_cidr_block         = "10.32.20.0/22"
  vnet_subnet_cidr_block  = "10.32.20.0/24"
  instance_template_data  = {
    tailscale_key   = var.tailscale_key,
    tailscale_hostname = format("%s-spoke-vnet-b", var.project_prefix)
  }
  custom_tags             = {
    Name  = "${var.project_prefix}-spoke-vnet-b"
    Owner = var.owner_tag
  }
  ssh_public_key          = var.ssh_public_key
}

output "spoke_vnet_a" {
  value = module.spoke_vnet_a
}
output "spoke_vnet_b" {
  value = module.spoke_vnet_b
}
