# Calling Modules

In the last section, you learned how to take existing Terraform code and turn it into a generalized module. Now that we have this module, let's use it!

In the last section, you created a `dev` and `prod` folder within the `\terraform` folder. In this exercise, you'll be creating Terraform code in each folder and referencing the `standard_application` module.

Let's get started. 

In the `dev` folder, create a new `main.tf` file. 

> **Don't forget the provider!**
>
> Remember when we got rid of the provider declaration in the `standard_application\main.tf` file earlier in this chapter? We are going to declare the provider in this file `dev\main.tf`. If a provider is not declared in a module, the module will use the provider of the configuration file that called the module. 
>
> It is generally best to keep provider declarations at the root folder where modules will be called. Only declare a provider in a module when you need to override the default provider used (like when you need to use a specific provider version for compatibility).

Open the `dev\main.tf` file you just created and paste the following code (or the provider code you saved earlier):

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    skip_provider_registration = true
    client_id       = ""
    client_secret   = ""
}
```

Just like before, make sure to place your Azure Tenant and Subscription ID inside the quotes next to the appropriate parameter.

Next we are going to call the previously created `standard_application` module and supply the required values. 

> **Module inception?**
>
> If you recall, modules are simply a folder with Terraform code within. So technically, the new `main.tf` file you created *is* a module...and we'll be adding code to call the *standard_application* module. In other words, modules can call other modules. 
>
> We're going to call the "standard_application" module to generate both a dev environment and a prod environment (hence the `dev` and `prod` folders). In large deployments, this saves us time. It also reduces the chance of errors because we know the same infrastructure will be deployed -- using the standards that we have set in the module (for naming convention, etc.).

Paste the following code below the provider block:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "dev"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
}
```

To call a module, declare it with a module {} block. The name of the module can be anything you want. In our case the name is `standard_application`. The source parameter specifies where the module is located in the file system, relative to the current file. The rest of the parameters are the variables we created earlier. Remember, any variable without a default value must be supplied by the user when calling the module directly.

It's good to know that modules don't have to be located on your local file system - they can be located in an external location. Tht's a more advanced topic, and we're not going to cover it in today's workshop. Feel free to investigate further if you're interested.

## Testing your changes

Let's deploy the resources like we did before.

First make sure we are in the `terraform\dev` folder in our terminal. If not, change to the appropriate folder level:

```bash
cd terraform\dev
```

Run `terraform init` to initialize our configuration - you have to do this again because the new root `main.tf` file is located in a new sub-folder, `dev`.

```bash
terraform init
```

Next, run the `terraform plan` command. This isn't a required step for deployment but it is a good practice to follow in order to reduce potential errors.

```bash
terraform plan
```

If the output of the plan checks out, let's apply:

```bash
terraform apply
```

Type `yes` to confirm the deployment. The resources will deploy to your Azure subscription exactly as written. 

## Checking your deployment

Open the Azure Portal and look for the resource group you created. This should look similar to what we deployed manually. Only now, we can deploy this as many times as we want with different values and it will return unique `standard_application` infrastructure deployments, each with their own unique resource group.

## Don't forget prod!

Copy the `dev\main.tf` file into the `prod` folder, change a couple of the parameter values we supplied (to reference prod, instead of dev), and deploy terraform from the prod folder to see a "production" environment next to your "development" environment. Note: This is not required for the other modules.

Here's what your `prod/main.tf` file should look like:

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    skip_provider_registration = true
    client_id     = ""
    client_secret = ""
}

module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "prod"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
}
```

_This concludes the exercise._

## What you've learned

Well done! Another section down and you've learned how to make re-usable modules in Terraform. 
