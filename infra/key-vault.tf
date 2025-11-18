resource "azurerm_key_vault" "one_ring" {
  for_each = local.environment_settings

  name                = "kv-${each.value.realm}-one-ring-${each.key}"
  resource_group_name = azurerm_resource_group.middleearth[each.key].name
  location            = azurerm_resource_group.middleearth[each.key].location

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.key_vault_allowed_ipv4

    virtual_network_subnet_ids = [
      azurerm_subnet.app[each.key].id,
    ]
  }

  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  tags = each.value.tags
}

resource "azurerm_key_vault_access_policy" "app" {
  for_each = local.environment_settings

  key_vault_id = azurerm_key_vault.one_ring[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.app[each.key].principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}
