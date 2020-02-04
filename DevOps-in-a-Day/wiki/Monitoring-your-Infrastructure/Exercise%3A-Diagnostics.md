# Exercise: Enabling Diagnostics

First, let's start by setting up diagnostics for all of our eligible resources. Open the [Azure Portal](https://portal.azure.com) and type in the Azure search bar at the top of the portal page: `monitor` and click on the Monitor service.

In the Monitor blade, on the left-hand navigation menu, click on *Diagnostic settings* under the **Settings** section. You should see a list of all the eligible resources for diagnostics. Notice, not all resources are listed - as not all resources have diagnostic capabilities.

For each resource listed (at a minimum make sure to do this for the Application Gateway resource), use the following steps to enable diagnostics:

1. Click on the resource listed in the `Monitor - Diagnostics settings` page.
2. Click add diagnostics setting
3. Provide a name for the diagnostics (try resource shortname with a diag suffix, ex: 'waf-diag')
4. Select `Archive to a storage account`
5. Click the `Storage account` area to select which storage account to store the diagnostics data in (choose the one we have already provisioned)
6. Select all log and metric options.

>**Data Retention**
>
>To retain data forever, we can leave the Retention (in days) section at 0. Keep in mind, this will bloat the amount of data being stored over time, and incur higher and higher charges as a result. It is recommended to set a retention policy that makes sense for your trend analysis plans. If you want to look at data over a longer period of time, you may want to stream that data to a reporting solution like **PowerBI**.

7. Click Save to save the diagnostics policy
8. Return to the `Monitor - Diagnostics settings` page until all resources show a `Diagnostics status` of *Enabled*

## Re-define your diagnostics once you learn more

As you enabled diagnostics for each resource, you probably noticed that resources have different sets of logs and metrics. It is recommended to enable all diagnostics as a starting point for resources. As you refine your monitoring through iterative operations and trend analysis, you may find you are not using some of these diagnostics. You can always change your diagnostics settings later as you learn more about how you are using them. This is partially why these diagnostic plans are named and saved.

## Practical diagnostics

Rather than enabling diagnostics one at a time through the portal, there is a better method. You should add the same diagnostics settings as part of the Terraform configuration files. Adding these configurations will take some deliberate understanding of which metrics and logs are available for different resource types.

## Reviewing Diagnostics

Once you have diagnostics enabled, you will be able to see performance statistics and logs in each of the resources deployed earlier in this workshop. Let's check out the Application Gateway to preview these metrics. Type in the Azure search bar at the top of the portal page: `application gateway` and click on the Application Gateway resource.

You will notice the Overview page of the Application Gateway now has a series of performance metrics running. We can pin any of these graphs to our dashboard by clicking the Pin icon on the top right of each graph. You can also create your own graphs in Azure Monitor in the Metrics section (and pin these to your dashboard as well). These are a great way to create meaningful landing pages like this:

![Dashboard](\.attachments\images\Monitoring-your-Infrastructure\dashboard.png)