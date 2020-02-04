# Deploying resources with Terraform

Within Visual Studio Code, open a Terminal. Click "Terminal > New Terminal", then hit Enter.

In the terminal, navigate to the `terraform` folder where you created the `main.tf` file. 

```
cd terraform 
```

Initialize Terraform:

```
terraform init
```

> **What does initialization do?**
>
> The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.
>
> Behind the scenes, `terraform init` downloads any needed providers (like the AzureRM provider) when run, and ensures your code can run.

You can see the effects of running `terraform init` from within VS Code: a `.terraform` folder is created, containing the AzureRM provider for your operating system:

![init](\.attachments\images\Getting-Started-with-Terraform\init.png)

Next, let's see what our terraform will create. Run the Terraform plan command:

```bash
terraform plan
```

The `terraform plan` command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state. For example, `terraform plan` might be run before committing a change to version control, to create confidence that it will behave as expected. You may also use `terraform plan` and save the output as part of an approval process before making the changes permanent.

Finally, use Terraform to make the changes to your environment. Run `terraform apply`. When prompted, type 'yes' to confirm you want to deploy the resources.

```bash
terraform apply
```

The resources will deploy to your Azure subscription exactly as written. 

![apply](\.attachments\images\Getting-Started-with-Terraform\apply.png)

## Checking your Deployment

Open the Azure Portal (https://portal.azure.com) and look for the resource group you created. Find the app service you deployed and click into the resource. On the main overview page you can find the default URL of the application service. Click on this link. 

You now have a base web application infrastructure where code can be deployed. Congrats! 

_This concludes the exercise._

## Clean up Resources

It's probably easiest to navigate to the Azure portal and delete the App Service Plan and App Service you created. 

Do that now. 

## What's Next

In the next section, we'll talk about how we can reformat this basic configuration file to be reusable.
