variable "deploy_environments" {
  description = "List of environments to deploy (e.g. [\"dev\", \"prod\"])."
  type        = list(string)
  default     = ["dev", "prod"]

  validation {
    condition = alltrue([
      for env in var.deploy_environments : contains(["dev", "prod"], env)
    ])
    error_message = "deploy_environments may only contain dev and/or prod."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "uksouth"
}

variable "project_name" {
  description = "Logical project name used for naming resources."
  type        = string
  default     = "middleearth"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    project     = "middleearth"
    managed_by  = "adroit"
    cost_centre = "fellowship"
  }
}

variable "key_vault_allowed_ipv4" {
  description = "List of IPv4 CIDR ranges permitted to access the One Ring Key Vault."
  type        = list(string)
  default     = []
}
