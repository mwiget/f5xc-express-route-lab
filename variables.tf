variable "project_prefix" {
  type        = string
  default     = "mw"
}

variable "azure_region" {
  type        = string
  default     = "eastus2"
} 

variable "azure_subscription_id" {
  type        = string
  default     = ""
} 

variable "azure_tenant_id" {
  type        = string
  default     = ""
} 

variable "azure_client_id" {
  type        = string
  default     = ""
} 

variable "azure_client_secret" {
  type        = string
  default     = ""
} 

variable "tailscale_key" {
  type        = string
}

variable "ssh_public_key" {
  type        = string
}
 
variable "owner_tag" {
  type        = string
  default     = "m.wiget@f5.com" 
}

variable "f5xc_azure_cred" {
  type = string         
}

variable "f5xc_api_url" {       
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_cert" {
  type = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
  default = ""
}

variable "express_route_circuit_id" {
  type = string
  default = ""
}

