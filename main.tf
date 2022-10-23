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

module "azure-site-1" {
  source                              = "./modules/f5xc/site/azure"
  f5xc_namespace                      = "system"
  f5xc_tenant                         = var.f5xc_tenant
  f5xc_azure_cred                     = var.f5xc_azure_cred
  f5xc_azure_region                   = var.azure_region
  f5xc_api_url                        = var.f5xc_api_url
  f5xc_api_token                      = var.f5xc_api_token
  f5xc_azure_site_name                = format("%s-azure-site-1", var.project_prefix)
  f5xc_azure_vnet_site_resource_group = format("%s-azure-site-1-rg", var.project_prefix)
  f5xc_azure_vnet_primary_ipv4        = "10.64.0.0/22"
  f5xc_azure_ce_gw_type               = "multi_nic"
  f5xc_azure_az_nodes                 = {
    node0 : {
      f5xc_azure_az                  = "1", f5xc_azure_vnet_inside_subnet = "10.64.0.0/24",
      f5xc_azure_vnet_outside_subnet = "10.64.1.0/24"
    }
    node1 : {
      f5xc_azure_az                  = "2", f5xc_azure_vnet_inside_subnet = "10.64.0.0/24",
      f5xc_azure_vnet_outside_subnet = "10.64.1.0/24"
    }
    node2 : {
      f5xc_azure_az                  = "3", f5xc_azure_vnet_inside_subnet = "10.64.0.0/24",
      f5xc_azure_vnet_outside_subnet = "10.64.1.0/24"
    }
  }
  f5xc_azure_hub_spoke_vnets          = [
    {
      resource_group                  = module.spoke_vnet_a.resource_group.resource_group.name
      vnet_name                       = module.spoke_vnet_a.vnet.name
      auto                            = true
      manual                          = false
      labels                          = {}
    },
    {
      resource_group                  = module.spoke_vnet_b.resource_group.resource_group.name
      vnet_name                       = module.spoke_vnet_b.vnet.name
      auto                            = true
      manual                          = false
      labels                          = {}
    }
  ]
  # f5xc_azure_express_route_connections = [
  #   {
  #     name                            = "solution-team"
  #     description                     = "connection into SJC lab"
  #     circuit_id                      = var.express_route_circuit_id
  #     weight                          = 10
  #   }
  # ]
  # f5xc_azure_express_route_sku_standard = true
  f5xc_azure_default_blocked_services = false
  f5xc_azure_default_ce_sw_version    = true
  f5xc_azure_default_ce_os_version    = true
  f5xc_azure_no_worker_nodes          = true
  f5xc_azure_total_worker_nodes       = 0
  public_ssh_key                      = var.ssh_public_key
  custom_labels                         = { "virtualSite" = "marcel-vsite" }
}

module "aws-site-1" {
  source                          = "./modules/f5xc/site/aws/vpc"
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-1"
  f5xc_aws_cred                   = "mw-aws-f5"
  f5xc_aws_vpc_site_name          = format("%s-aws-site-1", var.project_prefix)
  f5xc_aws_vpc_name_tag           = format("%s-aws-site-1", var.project_prefix)
  f5xc_aws_vpc_primary_ipv4       = "192.168.168.0/21"
  f5xc_aws_vpc_total_worker_nodes = 0
  f5xc_aws_ce_gw_type             = "multi_nic"
  f5xc_aws_vpc_az_nodes           = {
    node0 = {
      f5xc_aws_vpc_workload_subnet = "192.168.168.0/26", f5xc_aws_vpc_inside_subnet = "192.168.168.64/26",
      f5xc_aws_vpc_outside_subnet  = "192.168.168.128/26", f5xc_aws_vpc_az_name = "us-east-1a"
    }
  }
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_vpc_no_worker_nodes         = true
  f5xc_aws_vpc_use_http_https_port     = true
  f5xc_aws_vpc_use_http_https_port_sli = true

  f5xc_aws_vpc_direct_connect_disabled      = false
  f5xc_aws_vpc_direct_connect_manual_gw     = true
  f5xc_aws_vpc_direct_connect_standard_vifs = true
  f5xc_aws_vpc_direct_connect_custom_asn    = 65110
  public_ssh_key                            = var.ssh_public_key
  f5xc_labels                               = { "virtualSite" = "marcel-vsite" }

  providers = {
    aws = aws.us-east-1
  }
}

output "azure-site-1" {
  value = module.azure-site-1
}
output "spoke_vnet_a" {
  value = module.spoke_vnet_a
}
output "spoke_vnet_b" {
  value = module.spoke_vnet_b
}
output "aws-site-1" {
  value = module.aws-site-1
}
