# Terraform-azure-vpn

# Terraform Azure Cloud Vpn Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Authors](#authors)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This repository contains Terraform code to deploy resources on Microsoft Azure, including a resource group and a virtual network peering.

## Usage
To use this module, you should have Terraform installed and configured for AZURE. This module provides the necessary Terraform configuration
for creating AZURE resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples

# Example: point-to-site-with-ad

```hcl
module "vpn" {
  depends_on          = [module.vnet]
  source              = "git::https://github.com/opsstation/terraform-azure-vpn.git?ref=v1.0.1"
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
```

# Example: point-to-site-with-certificate

```hcl
module "vpn" {
  source              = "git::https://github.com/opsstation/terraform-azure-vpn.git?ref=v1.0.1"
  depends_on           = [module.vnet]
  name                 = local.name
  environment          = local.environment
  vpn_with_certificate = true
  resource_group_name  = module.resource_group.resource_group_name
  subnet_id            = module.subnet.specific_subnet_id[0]
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
  vpn_client_configuration_c = {
    address_space        = "172.16.201.0/24"
    vpn_client_protocols = ["OpenVPN", "IkeV2"]
    certificate          = <<EOF
MIIC5jCCAc6gAwIBAgIIUeUhLYf6UNwwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UE
AxMGVlBOIENBMB4XDTIyMTExMTE0MzA1NFoXDTI1MTExMDE0MzA1NFowETEPMA0G
A1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6bxr
s1kwbRztA7mH79EoIlyZsmAhdIXV8ehbzNIank1ByOqtBpQK1Xvde1z6rjL1hzCn
XD6xjW+xfF+yQ/zMyc6udrK2OvtuFmAsBYL5Bbb+Nf7U6Rp9IWZA6f/HO+XLft6q
sC0UD1wEK6LSn/1u+fCfT3UCMCjpskAtE3ossZCuhUjJ8jGNUb07Z84dQEQf0s3n
13V0kqNfpaxAhlWUVWrvKWlEGigoTqk6NcTNAzUEGR1b4Rt8qNzIwk8DhODfiOwT
ILsB3XWyA/IOv2eL3Eqx/lkykIBSEJALPE7j6igyTMoSPHtQA7NWrgYeWgiWh1AQ
VJpuY1vAIm3gfMAEoQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB
/wQEAwIBBjAdBgNVHQ4EFgQUiEbr34wufRJ6+1Fh5am89bxRCuswDQYJKoZIhvcN
AQELBQADggEBABHs7e6X2uLpUPkfv0r8TH3MnskPEGObcqGDS8WWH0FO7hsbSMeZ
bTxJue6WTUvwrxYrmfqRZU/K+TtDregsa+GAYsl0wbl82nu2gBivpARLXYenfmwc
Zgul+ZwQPw7FB9rLugW7qKMhGUxYYnywTyfZI1EjP6ZAjYn7xB9G7zOGpkVCErPn
LIO1Knhk7J2XIXs6wCw1OcLJfXhjEEbnYZaHYA3LCTot9LM+3ecloILUo7rQgooB
4/YOgmo7Q3Qv0ahFvsEI/ZqSop6NpLlzIQ/T3hC/6m4aG/1u+yaac4E9ygZNg184
Mb0BNzEPxRFt+L8A72gd/nTcxGrxEcQlqEc=
EOF
  }
}
```

# Example: site-to-site

```hcl
module "vpn" {
  depends_on          = [module.vnet]
  source              = "git::https://github.com/opsstation/terraform-azure-vpn.git?ref=v1.0.1"
  name                = "site-to-site"
  environment         = local.environment
  sts_vpn             = true
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.subnet.specific_subnet_id[0]
  gateway_type        = "Vpn"
  #### enable diagnostic setting
  diagnostic_setting_enable  = false
  log_analytics_workspace_id = ""
  local_networks = [
    {
      local_gw_name         = "app-test-onpremise"
      local_gateway_address = "20.232.135.45"
      local_address_space   = ["30.1.0.0/16"]
      shared_key            = "xpCGkHTBQmDvZK9HnLr7DAvH"
    },
  ]
}
```

This example demonstrates how to create various AZURE resources using the provided modules. Adjust the input values to suit your specific requirements.

# Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/opsstation/terraform-azure-vpn/blob/master/example) directory within this repository.

# License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/opsstation/terraform-azure-vpn/blob/master/LICENSE) file for more details.

# Authors
Your Name
Replace **MIT** and **OpsStation** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=2.90.0 |
| <a name="provider_azurerm.peer"></a> [azurerm.peer](#provider\_azurerm.peer) | >=2.90.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peering_back](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peering_back_diff_subs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias_subs_id"></a> [alias\_subs\_id](#input\_alias\_subs\_id) | Alias for remote provider in module. | `string` | `""` | no |
| <a name="input_allow_forwarded_traffic_vnet1"></a> [allow\_forwarded\_traffic\_vnet1](#input\_allow\_forwarded\_traffic\_vnet1) | Controls if forwarded traffic from VMs in the remote virtual network is allowed | `bool` | `false` | no |
| <a name="input_allow_forwarded_traffic_vnet2"></a> [allow\_forwarded\_traffic\_vnet2](#input\_allow\_forwarded\_traffic\_vnet2) | Controls if forwarded traffic from VMs in the remote virtual network is allowed | `bool` | `false` | no |
| <a name="input_allow_forwarded_traffic_vnet_diff_subs"></a> [allow\_forwarded\_traffic\_vnet\_diff\_subs](#input\_allow\_forwarded\_traffic\_vnet\_diff\_subs) | Controls if forwarded traffic from VMs in the remote virtual network is allowed | `bool` | `false` | no |
| <a name="input_allow_gateway_transit_vnet1"></a> [allow\_gateway\_transit\_vnet1](#input\_allow\_gateway\_transit\_vnet1) | Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. | `bool` | `false` | no |
| <a name="input_allow_gateway_transit_vnet2"></a> [allow\_gateway\_transit\_vnet2](#input\_allow\_gateway\_transit\_vnet2) | Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. | `bool` | `false` | no |
| <a name="input_allow_gateway_transit_vnet_diff_subs"></a> [allow\_gateway\_transit\_vnet\_diff\_subs](#input\_allow\_gateway\_transit\_vnet\_diff\_subs) | Controls gatewayLinks can be used in the different subscription virtual network’s link to the local virtual network. | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | Controls if the VMs in the remote virtual network can access VMs in the local virtual network. | `bool` | `true` | no |
| <a name="input_diff_subs_resource_group_name"></a> [diff\_subs\_resource\_group\_name](#input\_diff\_subs\_resource\_group\_name) | The name of remote resource group to be imported. | `string` | `""` | no |
| <a name="input_different_rg"></a> [different\_rg](#input\_different\_rg) | Flag to tell whether peering is to be done in same in resource group or different resource group | `bool` | `false` | no |
| <a name="input_enabled_diff_subs_peering"></a> [enabled\_diff\_subs\_peering](#input\_enabled\_diff\_subs\_peering) | n/a | `bool` | `false` | no |
| <a name="input_enabled_peering"></a> [enabled\_peering](#input\_enabled\_peering) | Set to false to prevent the module from creating any resources. | `bool` | `false` | no |
| <a name="input_resource_group_1_name"></a> [resource\_group\_1\_name](#input\_resource\_group\_1\_name) | The name of 1st existing resource group to be imported. | `string` | `""` | no |
| <a name="input_resource_group_2_name"></a> [resource\_group\_2\_name](#input\_resource\_group\_2\_name) | The name of 2nd existing resource group to be imported. | `string` | `""` | no |
| <a name="input_use_remote_gateways_vnet1"></a> [use\_remote\_gateways\_vnet1](#input\_use\_remote\_gateways\_vnet1) | Controls if remote gateways can be used on the local virtual network | `bool` | `false` | no |
| <a name="input_use_remote_gateways_vnet2"></a> [use\_remote\_gateways\_vnet2](#input\_use\_remote\_gateways\_vnet2) | Controls if remote gateways can be used on the local virtual network | `bool` | `false` | no |
| <a name="input_use_remote_gateways_vnet_diff_subs"></a> [use\_remote\_gateways\_vnet\_diff\_subs](#input\_use\_remote\_gateways\_vnet\_diff\_subs) | Controls if remote gateways can be used on the different subscription virtual network | `bool` | `false` | no |
| <a name="input_vnet_1_id"></a> [vnet\_1\_id](#input\_vnet\_1\_id) | The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_vnet_1_name"></a> [vnet\_1\_name](#input\_vnet\_1\_name) | The name of the virtual network. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_vnet_2_id"></a> [vnet\_2\_id](#input\_vnet\_2\_id) | The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_vnet_2_name"></a> [vnet\_2\_name](#input\_vnet\_2\_name) | The name of the remote virtual network. | `string` | `""` | no |
| <a name="input_vnet_diff_subs_id"></a> [vnet\_diff\_subs\_id](#input\_vnet\_diff\_subs\_id) | The id of the remote virtual network. | `string` | `""` | no |
| <a name="input_vnet_diff_subs_name"></a> [vnet\_diff\_subs\_name](#input\_vnet\_diff\_subs\_name) | The name of the remote virtual network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_peer_1_id"></a> [vnet\_peer\_1\_id](#output\_vnet\_peer\_1\_id) | The id of the newly created virtual network peering in on first virtual netowork. |
| <a name="output_vnet_peer_1_name"></a> [vnet\_peer\_1\_name](#output\_vnet\_peer\_1\_name) | The name of the newly created virtual network peering in on first virtual netowork. |
| <a name="output_vnet_peer_2_id"></a> [vnet\_peer\_2\_id](#output\_vnet\_peer\_2\_id) | The id of the newly created virtual network peering in on second virtual netowork. |
| <a name="output_vnet_peer_2_name"></a> [vnet\_peer\_2\_name](#output\_vnet\_peer\_2\_name) | The name of the newly created virtual network peering in on second virtual netowork. |
| <a name="output_vnet_peer_diff_subs_id"></a> [vnet\_peer\_diff\_subs\_id](#output\_vnet\_peer\_diff\_subs\_id) | The id of the newly created virtual network peering in on different subscription virtual netowork. |
| <a name="output_vnet_peer_diff_subs_name"></a> [vnet\_peer\_diff\_subs\_name](#output\_vnet\_peer\_diff\_subs\_name) | The name of the newly created virtual network peering in on different subscription virtual netowork. |
<!-- END_TF_DOCS -->