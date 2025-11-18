terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azurerm" {
  features {}

  # NOTE:
  # Subscription details intentionally omitted for this exercise.
}

data "azurerm_client_config" "current" {}

locals {
  environment_defaults = {
    dev = {
      realm     = "shire"
      vnet_cidr = "10.10.0.0/20"
    }

    prod = {
      realm     = "gondor"
      vnet_cidr = "10.20.0.0/20"
    }
  }

  selected_environments = {
    for env in var.deploy_environments :
    env => local.environment_defaults[env]
  }

  environment_settings = {
    for env, cfg in local.selected_environments :
    env => merge(cfg, {
      app_subnet_prefix = cidrsubnet(cfg.vnet_cidr, 4, 0)
      tags = merge(
        var.tags,
        {
          environment = env
          realm       = cfg.realm
        }
      )
    })
  }
}
