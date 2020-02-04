# Exercise: Getting started

Before we get started, let's create a folder within your Git repository. On your VM, create a folder in the root of your Git repo named `terraform`. We'll be working from this folder throughout the workshop.

Next, open Visual Studio Code, open the `terraform` folder you created, then create a new file. We are going to name this file `main.tf`. This is one of the standard file names used in Terraform. We will talk about the others later in the workshop.

> **What is a main.tf file?**
>
> The `main.tf` file is where we will declare our instructions to Azure for what infrastructure we want to deploy and how we want to deploy the infrastructure. 

The first thing we need to do is tell Terraform to use the Azure RM Provider. 

Copy and paste the below section to the top of your `main.tf` file:

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    skip_provider_registration = true
    client_id       = ""
    client_secret   = ""
}
```

Make sure to place your Azure Tenant ID, Subscription ID, Client ID, and Client Secret inside the quotes next to the appropriate parameter. 

> **Where do I find these IDs and Secret?**
>
> Take a look at the login information we provided you for the workshop, it will include your Tenant Id and Subscription Id. You can also find this information in the Azure Portal. If you'd like to know where to find these values in the Azure Portal check out this brief video.

![ids](\.attachments\images\Getting-Started-with-Terraform\ids.gif)

Note - your Tenant ID is the Azure Active Directory Directory ID.

_This concludes the exercise._