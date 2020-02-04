# Exercise: Using Terraform State

Now that we have a storage account, let's update our Terraform code to use it.

Before we get started, collect the following information:

1. Storage account name: this is the name your wrote down in the previous section.
2. Subscription ID: The id of your Azure subscription (you should already have this saved in your `main.tf` file).
3. Tenant ID: The id of your Azure tenant (you should already have this saved in your `main.tf` file).

## Updating the dev main.tf file

Open your `main.tf` for dev and add the following terraform code to the top of the file.

```json
terraform {
  backend "azurerm" {
    storage_account_name = ""
    resource_group_name  = ""
    container_name       = "dev"
    key                  = "terraform.tfstate"
    tenant_id            = ""
    subscription_id      = ""
    client_id            = ""
    client_secret        = ""
  }
}
```

Update the code by changing the values for `storage_account_name`, `resource_group_name`, `tenant_id`, `subscription_id`, `client_id`, and `client_secret`.

## Updating the prod main.tf file

Open your `main.tf` for prod and add the following terraform code to the top of the file.

```json
terraform {
  backend "azurerm" {
    storage_account_name = ""
    resource_group_name  = ""
    container_name       = "prod"
    key                  = "terraform.tfstate"
    tenant_id            = ""
    subscription_id      = ""
    client_id            = ""
    client_secret        = ""
  }
}
```

Update the code by changing the values for `storage_account_name`, `resource_group_name`, `tenant_id`, `subscription_id`, `client_id`, and `client_secret`.

## Testing your changes

Navigate to the `dev` directory, where `main.tf` exists. Initialize Terraform. When running the init command, you may be prompted with the following message:

> Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "azurerm" backend. No existing state was found in the newly
  configured "azurerm" backend. Do you want to copy this state to the new "azurerm"
  backend? Enter "yes" to copy and "no" to start with an empty state.

If you see this message, enter `yes` to continue.

```bash
terraform init
```

> **But I already initialized once**
>
> Yes, that is true, but since you've updated the backend configuration, you'll need to re-initialize Terraform to ensure it talks to your backend.

Apply the changes:

```bash
terraform apply
```

Verify that Terraform ran successfully, then check the storage account to ensure a `terrform.tfstate` file exists in the `dev` blob container:

![tfstate](\.attachments\images\Managing-Terraform-State\tfstate.png)

> **Don't forget about prod!***

Before you continue, re-initialize `prod` and run `terraform apply`. Validate the `terraform.tfstate` file exists in the prod blob container before continuing.

_This concludes the exercise._

## What you Learned

In this section, you learned why Terraform state files are important, and how to configure a Terraform backend to automatically store and retrieve the state file. 

_This concludes the section._