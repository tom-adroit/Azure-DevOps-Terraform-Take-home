
---

## `QUESTIONS.md`

```markdown
# Middle-earth DevOps – Questions

Please answer briefly in your own words. Bullet points or short paragraphs are fine.

---

## 1. Terraform design

- How did you approach the dev/prod split?
  - I chose to use variables and define them through a list of strings. This would make easier to add other environments whenever needed. Also, to create new values based on the environments this can help me to make it more reusable and also more understandable.

- How would this approach scale if we later add a third realm (for example, **Rohan**)?
  - Same way, but it can get really confusing if we keep adding more and more environments. For this, it is better to create other repositories for dedicated resources.
---

## 2. CI/CD integration

- How would you plug this Terraform into a pipeline using **GitHub Actions** or **Azure DevOps**?
  - Definitely a gated pipeline that uses fmt, validate and plan as part of the pipeline, and only after that the apply should be triggered with the proper approvals, and always only from the pipeline, not allowing any developer to touch into production environment.
- How would you:
  - Handle secrets (e.g. Azure credentials, state backend access)?
    - Inserting them inside secret stores, so with that I can use exclusive variables to overwrite during the time of execution.

  - Prevent accidental prod deployments from a developer’s laptop?
    - Defining through RBAC that developers can only have tests on development environment with a contributor role on Azure, and only read access into production. Also, using only a protected state backend, with that only the pipeline would have access to the remote tfstate file to execute the modifications.

---

## 3. AI usage

If you used AI tools (e.g. ChatGPT, Copilot), please answer:

- What did you use them for?
  -Help me split into modules, to make it easier to work, but I still had to make some modifications to better organize but it is alreaedy enough for a human to read the code. Also, to have some faster troubleshooting with some issues,since I don't created an Azure account to perform the tests.

- How did you validate or adjust the output?
  - Testing with terraform validate, checking the logs and adjusting accordingly with the error. Sometimes, researching on stack overflow what the AI sent to me to understand why about that error.
- Is there anything you chose not to use? Why?
  - I chose to use AI because this would help me to see things that I could possibly can't see properly, and also having more time to debug and deliver this challenge.
---

## 4. If you had more time…

- If you had another few hours, what would you improve or refactor in your solution?
  - I would definitively try to use terragrunt to better split the code for better reusability and improve the documentation. But one thing that makes me happy is that this is a really good start of project. 
(Structure, modules, linting, testing, naming, documentation, anything you like.)
