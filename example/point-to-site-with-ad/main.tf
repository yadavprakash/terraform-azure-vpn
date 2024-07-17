provider "azurerm" {
  features {}
  subscription_id = ""
}



locals {
  name        = "yadavprakash"
  environment = "test"
}


##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------

module "resource_group" {
  source      = "git::https://github.com/yadavprakash/terraform-azure-resource-group.git?ref=v1.0.0"
  name        = local.name
  environment = local.environment
  location    = "Canada Central"
}

##-----------------------------------------------------------------------------
## Virtual Network module call.
## Virtual Network in which vpn subnet(Gateway Subnet) will be created.
##-----------------------------------------------------------------------------

module "vnet" {
  source              = "git::https://github.com/yadavprakash/terraform-azure-vnet.git?ref=v1.0.0"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnet module call.
## Name specific subnet for vpn will be created.
##-----------------------------------------------------------------------------

module "subnet" {
  source               = "git::https://github.com/yadavprakash/terraform-azure-subnet.git?ref=v1.0.1"
  name                 = local.name
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet[*].vnet_name)
  #subnet
  specific_name_subnet  = true
  specific_subnet_names = "GatewaySubnet"
  subnet_prefixes       = ["10.0.1.0/24"]
  # route_table
  enable_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##-----------------------------------------------------------------------------
## VPN module call.
## Following module will deploy point to site vpn in azure infratsructure.
##-----------------------------------------------------------------------------

module "vpn" {
  depends_on          = [module.vnet]
  source              = "../../"
  name                = local.name
  environment         = local.environment
  vpn_ad              = true
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.subnet.specific_subnet_id[0]
  vpn_client_configuration = {
    address_space        = "172.16.200.0/24"
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_tenant           = "https://login.microsoftonline.com/d65b2035-4d4a-4b77-8fe7-964ea582db2b/"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/d65b2035-4d4a-4b77-8fe7-964ea582db2b/"
  }
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
}

