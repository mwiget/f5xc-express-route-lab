module "resource_group" {
  source                         = "../modules/azure/resource_group"
  azure_region                   = var.azure_region
  azure_resource_group_name      = format("%s-rg", var.vnet_name)
}

module "vnet" {
  source                         = "../modules/azure/virtual_network"
  azure_vnet_name                = var.vnet_name
  azure_vnet_primary_ipv4        = var.vnet_cidr_block
  azure_vnet_resource_group_name = module.resource_group.resource_group["name"]
  azure_region                   = module.resource_group.resource_group["location"]
}

module "azure_subnet" {
  source                           = "../modules/azure/subnet"
  azure_vnet_name                  = module.vnet.vnet["name"]
  azure_subnet_name                = format("%s-subnet", var.vnet_name)
  azure_subnet_address_prefixes    = [var.vnet_subnet_cidr_block]
  azure_subnet_resource_group_name = module.resource_group.resource_group["name"]
}

module "azure_security_group_workload" {
  source                       = "../modules/azure/security_group"
  azure_region                 = var.azure_region
  azure_resource_group_name    = module.resource_group.resource_group["name"]
  azure_security_group_name    = format("%s-nsg", var.vnet_name)
  azurerm_network_interface_id = element(module.workload.virtual_machine["network_interface_ids"], 0)
  azure_linux_security_rules   = [
    {
      name                       = "ALLOW_ALL"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }
  ]
  custom_tags = var.custom_tags
}

module "workload" {
  source                                     = "../modules/azure/linux_virtual_machine"
  azure_zone                                 = var.azure_az
  azure_zones                                = [var.azure_az]
  azure_region                               = module.resource_group.resource_group["location"]
  azure_resource_group_name                  = module.resource_group.resource_group["name"]
  azure_virtual_machine_size                 = "Standard_DS1_v2"
  azure_virtual_machine_name                 = format("%s-workload-vm", var.vnet_name)
  azure_linux_virtual_machine_custom_data    = base64encode(templatefile(format("%s/%s", local.template_input_dir_path, var.azure_instance_script_template_file_name), var.instance_template_data))
  azure_linux_virtual_machine_admin_username = "ubuntu"
  public_ssh_key                             = var.ssh_public_key
  custom_tags                                = var.custom_tags
  azure_network_interfaces = [
    {
      name             = format("%s-workload-if",var.vnet_name)
      tags             = { "tagA" : "tagValueA" }
      ip_configuration = {
        subnet_id                     = module.azure_subnet.subnet["id"]
        create_public_ip_address      = true
        private_ip_address_allocation = "Dynamic"
      }
    }
  ]
}
