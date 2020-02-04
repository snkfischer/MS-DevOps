# Terraform Modules

In the last section, you wrote your first Terraform code, and learned three Terraform commands: `init`, `plan`, and `apply`. As your Terraform code becomes more complex, and you work through more deployments, you may find the need to reuse Terraform code. You can do this with modules.

> **So what is a module in Terraform anyways?** 
>
> In the simplest terms, a module is a collection of declarative Terraform files, grouped together in a folder. That's right - Terraform sees any folder with Terraform files as a module. If you're familiar with other programming lanaguages, you can think of a module like an API - you pass data (variables) into it, infrastructure is provisioned, and data (output) is returned. 

You'll recall from the last chapter, that Terraform collects all `.tf` files in a folder (or rather, a module) when it runs. The files are combined into a single master code declaration, dependencies discovered, and infrastructure is provisioned in the order determined.

## Structuring modules

Modules consist of three files, generally:
1. A `main.tf` file where all primary code exists. 
2. A `variables.tf` or `vars.tf` file where variables for that module are declared. 
3. An `output.tf` file where any module outputs are declared. 

You've already seen what goes into a `main.tf` file so let's talk about the other two.

The variables file, is made up of all pre-defined variables (or module inputs) for a file. Here is an example of how to construct a variable:

```
variable "location" {
    description = "Location where Resources will be deployed"
    default = "East US"
}
```

The example above declares a `location` variable, which can include a description and a default value, though these are not required. If no default value is supplied, the module will expect these to be supplied by some other means, either through direct user input or by outputs.

Speaking of outputs, let's look at an example of what might go into an `output.tf` file:

```
output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}
```

The example above declares an `app_service_fqdn` output and specifies the value comes from the result of the app service default site hostname. This means we can use computed values from our deployment elsewhere. Like for example, in another module.

The ability for setting up inputs and outputs using declarative language gives us the flexibility needed to generalize configurations so they can be *stamped-out* on demand.

>**Another word on modules**
>
>Modules are not a be-all end-all with Terraform. Managing modules can be difficult, especially when it comes to updating and versioning interdependent modules. An equally valid approach for the code is having unique terraform files for each resource that makes up an application in an application-specific folder so that navigation of the environment can be done in an easier manner. The right path generally lies somewhere in the middle. But we are not going to get into a debate here, some online searches can go a long way into understanding the different approaches for organizing and managing your infrastructure as code repositories.
