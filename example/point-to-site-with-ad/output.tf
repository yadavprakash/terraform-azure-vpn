output "vpn_gw_id" {
  value       = join("", module.vpn[0].vpn_gw_id)
  description = "The ID of the Virtual Network Gateway."
}

