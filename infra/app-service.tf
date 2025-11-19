resource "azurerm_app_service_plan" "api" {
  for_each = local.environment_settings

  name                = "asp-${each.value.realm}-${each.key}"
  resource_group_name = azurerm_resource_group.middleearth[each.key].name
  location            = azurerm_resource_group.middleearth[each.key].location

  kind = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = each.value.tags
}

resource "azurerm_app_service" "api" {
  for_each = local.environment_settings

  name                      = "app-${each.value.realm}-api-${each.key}"
  resource_group_name       = azurerm_resource_group.middleearth[each.key].name
  location                  = azurerm_resource_group.middleearth[each.key].location
  app_service_plan_id       = azurerm_app_service_plan.api[each.key].id
  https_only                = true

  site_config {
    linux_fx_version = "DOTNETCORE|8.0"
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app[each.key].id]
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "REALM"                    = each.value.realm
    "ENVIRONMENT"              = each.key
  }

  tags = each.value.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "api" {
  for_each = local.environment_settings
  
  app_service_id    = azurerm_app_service.api[each.key].name
  subnet_id           = azurerm_subnet.app[each.key].id

  depends_on = [azurerm_app_service.api]
}