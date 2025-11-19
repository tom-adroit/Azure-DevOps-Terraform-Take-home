output "resource_group_names" {
  description = "Names of the Middle-earth resource groups per environment."
  value = {
    for env, rg in azurerm_resource_group.middleearth :
    env => rg.name
  }
}

output "api_default_hostnames" {
  description = "Default hostnames for the Middle-earth App Services."
  value = {
    for env, app in azurerm_app_service.api :
    env => app.default_site_hostname
  }
}

output "key_vault_names" {
  description = "Names of the One Ring Key Vault instances."
  value = {
    for env, vault in azurerm_key_vault.one_ring :
    env => vault.name
  }
}
