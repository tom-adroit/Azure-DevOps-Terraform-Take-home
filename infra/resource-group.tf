resource "azurerm_resource_group" "middleearth" {
  for_each = local.environment_settings

  name     = "rg-${var.project_name}-${each.key}"
  location = var.location

  tags = each.value.tags
}
