output "resource_group" {
  value = module.resource_group
}

output "vnet" {
  value = module.vnet.vnet
}

output "workload" {
  value = module.workload.virtual_machine
}

