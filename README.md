# Middle-earth DevOps – Terraform Take-home

Welcome to Adroit’s Middle-earth DevOps exercise.

This is a short, time-boxed take-home to give us a feel for how you work with Terraform, Git, and Azure concepts. It is designed to be completed in **around 40 minutes**.

You do **not** need an Azure subscription and you are **not** expected to run `terraform apply`. Focus on the code and your reasoning.

---

## Scenario

You have joined the Fellowship Platform Team, looking after a small Azure environment that supports two realms:

- **The Shire** (dev)
- **Gondor** (prod, to be added)

We’ve started a Terraform configuration in `infra/` to provision:

- A resource group for Middle-earth
- A virtual network for **Gondor**
- A subnet for an app
- An App Service plan and App Service for the **shire-api**
- A Key Vault for secrets (incomplete)

Your job is to clean this up and extend it so it is ready for both dev and prod, using good Terraform and Git practices.

---

## What you need

- Git
- Terraform CLI (v1.x)
- Any editor/IDE you like

You can use AI tools (ChatGPT, Copilot, etc.), but:
- You must understand what they produce.
- You must be able to explain every line you submit.
- We will ask you to walk through your solution on a follow-up call.

---

## Repository structure

You’ll see something like:

```text
.
├── infra
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md           # optional notes from us
├── QUESTIONS.md
└── this README.md
```

# Note
We’ve left some TODO and FIXME comments in the Terraform files for you to address.

# Tasks

## Part 1 – Terraform (core, ~30 minutes)

Work in the `infra/` folder.

### 1. Fix and complete the existing configuration

Open `infra/main.tf`. You will find a partially working configuration for:

- `azurerm_resource_group.middleearth`
- `azurerm_virtual_network.gondor`
- `azurerm_subnet.gondor_app`
- `azurerm_app_service_plan.shire_plan`
- `azurerm_app_service.shire_api`
- `azurerm_key_vault.one_ring` (incomplete)
- A managed identity resource (or a placeholder for one)

**Your tasks:**

Address all FIXME comments. These are small but meaningful issues. For example:

- Incorrect or inconsistent Azure locations
- Invalid address prefixes for VNets/subnets
- Wrong references between resources

Complete the `azurerm_key_vault` configuration (and any linked resources) so that:

- The shire-api App Service can read secrets using a managed identity.
- Access is restricted appropriately (no allow all from the internet).
- Naming remains consistent with the existing Middle-earth theme (e.g. `kv-one-ring`, tags like `realm = "shire"` are encouraged).

Make sure the configuration is structured so it could reasonably grow (e.g. variables used sensibly, no obviously hard-coded values that should be inputs).

You are welcome to run `terraform fmt` and `terraform validate` locally, but this is not required.

### 2. Add a prod environment for Gondor

We want to be able to deploy both dev (Shire) and prod (Gondor) with minimal duplication.

Using the existing code as a starting point:

Add support for a prod environment, with:

- A separate App Service instance, e.g. `shire-api-prod` or `gondor-api`.
- Distinct naming for resources (resource group, VNet, etc.) so dev and prod don’t clash.
- Separate address space for the prod VNet.

Avoid naive copy-paste where you can:

- Use variables, locals, or modules to keep things DRY.
- Keep it readable, we’re more interested in clear structure than clever tricks.

You do not need to create separate state backends, but if you want to sketch how you would do that, you can mention it in `QUESTIONS.md`.

## Part 2 – Git workflow (~10 minutes)

We’d like to see a bit of Git hygiene.

### Branching (preferred, if using GitHub):

- Create a feature branch, for example: `feature/middleearth-terraform`.
- Make at least two commits with meaningful messages (e.g. `feat: add prod environment for gondor` rather than `update stuff`).

### If you submit as a zip:

- If possible, include the `.git` folder so we can see your history.
- Or, write briefly in `QUESTIONS.md` how you would normally structure your commits and branches for this kind of change.

## Part 3 – Short questions (in `QUESTIONS.md`)

Open `QUESTIONS.md` and answer briefly (bullet points or short paragraphs are fine):

### Terraform design:
- Explain how you approached the dev/prod split.
- How would this scale if we later add a third realm (for example, Rohan)?

### CI/CD:
Describe, at a high level, how you would plug this Terraform into a pipeline using GitHub Actions or Azure DevOps.  
How would you:

- Handle secrets (e.g. Azure credentials, state backend access)?
- Stop someone accidentally deploying to prod from their laptop?

### AI usage:
If you used AI tools at any point, tell us:

- What you used them for.
- How you checked the output.
- Anything you chose to change or ignore.

### If you had more time:
- What would you improve or refactor in your solution?

Please keep answers honest and concise. We’re interested in how you think, not in essay length.

# Submission

You can submit your solution in either of the following ways:

## GitHub (preferred):

- Push your changes to a public repo in your own GitHub account.
- Send us the link.

## Zip file:

- Zip the repo folder (including `infra/`, `QUESTIONS.md`, and optionally the `.git` folder).
- Email it to: `hello@adroitcc.io`

# Follow-up

If we move forward, we’ll schedule a short call to:

- Walk through your Terraform changes.
- Ask you to explain key decisions.
- Discuss how you’d extend this for real-world use (networking, identity, monitoring, etc.).

You should be ready to share your screen and talk through the code in your own words.

May the logs be quiet and your plans apply cleanly. 🧙‍♂️
