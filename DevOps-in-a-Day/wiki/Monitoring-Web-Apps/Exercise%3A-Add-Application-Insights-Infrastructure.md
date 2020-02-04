# Exercise: Add Application Insights Infrastructure

Add an Application Insights resource to the `standard_application` Terraform module.

At the bottom of the `standard_application/main.tf` file add the following:

```
# Application Insights
resource "azurerm_application_insights" "ai" {
  name                = "tf-az-${var.application_name}-${var.environment}-appinsights"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  application_type    = "web"
}
```

Commit and push your code changes, then queue the build and release pipelines - when you're finished, 2x Application Insights instances will be deployed to Azure.

## Find the App ID and Instrumentation Key 

After the Application Insights resources have been deploy, navigate to each resource (dev and prod) and locate the App ID and Instrumentation Keys. 

The App ID can be found under the `API Access` page:

![App ID](/.attachments/images/Monitoring-Web-Apps/app1.png)

The Instrumentation Key can be found on the `Overview` page:

![App ID](/.attachments/images/Monitoring-Web-Apps/instrumentation1.png)

Save the dev and prod values for the next section.

_This concludes this exercise._