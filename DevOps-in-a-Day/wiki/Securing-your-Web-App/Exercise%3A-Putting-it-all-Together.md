# Exercise: Putting it all Together

Now that we have created our modules, we need to tie them together in a single deployment. We will do this from the `dev\main.tf` file we created in a previous chapter.

## Updating our root main.tf code

Open the `terraform\dev\main.tf` file.

Below the backend *azurerm* {} code block paste the following code:

```
module "core_services" {
    source                        = "../_modules/core_services/"

    environment                   = "dev"
    functional_name               = "core-services"
    location                      = "East US"
    virtual_network_address_space = "10.10.0.0/16"
    management_subnet             = "10.10.1.0/24" 
    gateway_subnet                = "10.10.2.0/24"
    application_name              = "app1"
    resource_group_name           = "${module.standard_application.resource_group_name}"    
}
```

This will create our core services. The Virtual Network will be created with a /16 address space and be carved up into two /24 subnets.

Next, we will add the following code after the module *standard_application* {} block:

```
module "shared_services" {
    source              = "../_modules/shared_services/"

    environment         = "dev"
    functional_name     = "shared-services"
    location            = "East US"
    application_name    = "app1"
    gateway_subnet_id   = "${module.core_services.gateway_subnet_id}"
    app_service_fqdn    = "${module.standard_application.app_service_fqdn}"
    resource_group_name = "${module.standard_application.resource_group_name}"    
}  
```

> **A reminder on Ordering**
>
> If you don't put these in the right order... that's okay! This is a declarative language. However, for ease of reading and logical ordering we are placing things in a specific order.

Notice the `gateway_subnet_id` and the `app_service_fqdn` variables are retrieving values from the other modules. Terraform will wait for those modules to complete before attempting to start deployment of the shared_services module. Module outputs can be retrieved using `${module.<module name>.<output name>}`. If no output is defined, the values cannot be retrieved directly from the module.

#### Deploying to Dev and Prod

With all the modules declared, we can now fully deploy our development environment. This time, we do not have to delete the previously created resources. This is because we have a state file from our previous module which will tell Terraform that one of the modules has already been deployed. Terraform will read the state file, verify the configurations match, then move on to deploying the new modules.

In our Terminal window, navigate to `terraform\dev`, then paste the following command:

```bash
terraform init
terraform plan
```

Once we have confirmed everything will deploy as expected, go ahead and run the apply:

```bash
terraform apply
```

Type `yes` to confirm the deployment. The resources will deploy to your Azure subscription exactly as written.

Next, let's copy our `dev\main.tf` file over to the prod folder. Once in the prod folder, go ahead and change the environment parameters values to *prod* (make sure to change this for each module called).

We can leave everything else the same. The ip addresses of the virtual network for production will overlap BUT the virtual networks are not connected with each other. So this will not cause any issues. In a real world scenario, the ip address spaces would likely be different even though they still probably wouldn't be connected to each other for the sake of resource isolation.

Now that you have the `prod\main.tf` file updated, open the terminal and cd to `terraform\prod`, then paste the following command:

```bash
terraform init
terraform plan
```

Once we have confirmed everything will deploy as expected, go ahead and run the apply:

```bash
terraform apply
```

When complete, you will now have two sets of environments deployed in your Azure Subscription, one for Development and one for Production.

_This concludes the exercise._

## Wrap up

Let's test our application...visit the Azure portal, find your web app, and navigate to the web app's URL.

Congrats! You now have a functioning, secure web application using infrastructure as code with Terraform!

## Commit your Code

If you haven't already, don't forget to commit your Terraform code and push the commits to the remote repository!

## Up Next

Now that you've reached the end of the infrastructure as code portion of the workshop, what's next?

We are going to focus on the build and release pipelines using Azure DevOps. This is where we will really start to see the line between Dev and Ops get blurred. Enjoy!