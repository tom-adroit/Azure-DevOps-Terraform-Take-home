# Middle-earth Infra (Terraform)

This folder contains a partially completed Terraform configuration for the Middle-earth environment:

- Resource Group
- Virtual Network and subnet
- App Service plan and App Service (`shire-api`)
- Key Vault (`one-ring`)
- A managed identity

Your task is to:

1. Fix issues and complete the existing configuration (`FIXME` / `TODO` comments in `main.tf`).
2. Extend the configuration to support a **prod** environment (**Gondor**) alongside **dev** (**The Shire**).
3. Keep the code readable and ready to grow.

You do **not** need to run `terraform apply` for this exercise.

## Recommended workflow

Even though `terraform apply` is out of scope, it is worth following a repeatable workflow so fmt/validate errors never make it
into version control:

1. `terraform fmt -recursive` to keep all files consistent.
2. `terraform init` to download the pinned provider versions.
3. `terraform validate` to catch syntax/reference issues quickly.
4. `terraform plan -var='deploy_environments=["dev","prod"]'` (or limit the list to a single realm) to review the concrete
   changes Terraform would make.

## Remote state & locking plan

The repo currently relies on local state for simplicity, but the target deployment model uses an Azure Storage Account backend
so state is centralized, encrypted, and automatically locked. The high-level approach is:

### 1. Storage layout

- Dedicated resource group, storage account, and `tfstate` container per subscription boundary (for example `rg-middleearth-tf`,
  `stmiddleearthtf`, `tfstate`).
- Enable soft delete and blob versioning so accidental deletions can be recovered.
- Require TLS 1.2+, disable public network access, and expose the account through a private endpoint to the pipeline network.

### 2. Safe locking mechanics

- The `azurerm` backend already uses Azure Blob leases for distributed locking. Configuring the backend in `main.tf` like below
  ensures only one plan/apply session can hold the lease at a time:

  ```hcl
  terraform {
    backend "azurerm" {
      resource_group_name  = "rg-middleearth-tf"
      storage_account_name = "stmiddleearthtf"
      container_name       = "tfstate"
      key                  = "middleearth/terraform.tfstate"
    }
  }
  ```

- Because locks rely on the caller acquiring a blob lease, the safest pattern is to restrict `Storage Blob Data Owner`
  permissions to the CI/CD identity only (see below). Engineers can still run `terraform plan` locally via
  `-backend=false` if they need ad-hoc experimentation, but production state changes always flow through the pipeline so the
  lock cannot be bypassed accidentally.

### 3. Access controls

- Use an Azure AD application (service principal) or workload identity federation tied to the pipeline (for example, a GitHub
  Actions OIDC trust) and grant it the minimum rights:
  - `Storage Blob Data Contributor` (or `Owner` if lifecycle management is needed) on the state container.
  - `Key Vault Secrets User`/`Reader` only when the pipeline must read bootstrap secrets.
  - Subscription or resource group–level `Contributor` + `User Access Administrator` only if Terraform needs to manage RBAC.
- Deny everyone else (including developers) direct access to the storage account by default. When a break-glass scenario occurs,
  use just-in-time (Privileged Identity Management) elevation and audit it.

### 4. Pipeline usage

- The pipeline authenticates via federated credentials (OIDC) to avoid storing client secrets.
- Each environment (`dev`, `prod`, future `qa`) maps to a pipeline stage with manual approvals and environment protection rules.
- Plans run for every pull request, but applies happen only after merge and successful approvals, ensuring the locked state is
  modified by a single, traceable process.

## Security guardrails roadmap

- **Branch protections & policy checks** – Require PR reviews, status checks (fmt/validate/plan), and signed commits before
  merging to `main`.
- **Scoped service principals** – Separate credentials per environment or subscription, each with least-privilege RBAC and the
  storage access described above.
- **Environment approvals** – Use Azure DevOps environments or GitHub Environments so prod applies require an approval group and
  optionally a change ticket ID.
- **Drift detection** – Schedule a nightly `terraform plan` (with `-lock=false`) to detect drift without taking the lease, and
  route failures to PagerDuty/Teams.
- **Secrets posture** – Store bootstrap secrets (for example, pipeline client certificates) in Azure Key Vault, accessed via the
  pipeline’s managed identity, so no plaintext secrets live in repository settings.

These guardrails keep the current multi-realm design ready for future environments (e.g., Rohan) without rewriting the Terraform
codebase.
