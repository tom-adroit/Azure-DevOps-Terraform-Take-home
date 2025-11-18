resource "azurerm_user_assigned_identity" "app" {
  for_each = local.environment_settings

  name                = "uai-${each.value.realm}-api-${each.key}"
  resource_group_name = azurerm_resource_group.middleearth[each.key].name
  location            = azurerm_resource_group.middleearth[each.key].location

  tags = each.value.tags
}
