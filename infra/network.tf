resource "azurerm_virtual_network" "middleearth" {
  for_each = local.environment_settings

  name                = "vnet-${each.value.realm}-${each.key}"
  resource_group_name = azurerm_resource_group.middleearth[each.key].name

  address_space = [
    each.value.vnet_cidr,
  ]

  location = azurerm_resource_group.middleearth[each.key].location
  tags     = each.value.tags
}

resource "azurerm_subnet" "app" {
  for_each = local.environment_settings

  name                 = "snet-${each.value.realm}-app-${each.key}"
  resource_group_name  = azurerm_resource_group.middleearth[each.key].name
  virtual_network_name = azurerm_virtual_network.middleearth[each.key].name

  address_prefixes = [
    each.value.app_subnet_prefix,
  ]

  service_endpoints = [
    "Microsoft.KeyVault",
  ]

  delegation {
    name = "delegate-app-service"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}
