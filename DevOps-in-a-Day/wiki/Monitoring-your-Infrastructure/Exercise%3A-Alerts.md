# Exercise: Alerts

Now that you have established diagnostics, we can use those in meaningful ways. In a DevOps world, we may not always be able to review dashboards to address performance concerns that may come up. This is where Alerts come into play. In order to establish alerts, we will need 3 things: **diagnostics**, **action group**, and an **alert rule** which ties together the resource diagnostics, the condition(*threshold*), the action group, and the alert details.

## Create an action group

First, let's return to our Azure Monitor service. Type in the Azure search bar at the top of the portal page: `monitor` and click on the Monitor service. Next, follow these steps to create an Action Group: 

1. click on the `Alerts` section, and `Manage actions`
2. click on `+ Add action group`
3. In Action group name, type: `DevOps Team`
4. In Short name, type: `DevOps`
5. Select the Resource group for our standard application
6. Under Actions, define a new action called: Email Team
7. For the `Action Type` choose `Email Azure Resource Manager Role`
8. Select the Owner role
9. Click OK to create the Action Group

>**Actions**
>
>You probably noticed there are a number of different actions that we can setup in an action group. Emailing is one of the primary methods of establishing baseline alerts, but in a real DevOps scenario we will likely want to do more than just notify the team or resource owner. We will likely want to create automation tasks (using an Automation Runbook, an Azure Function, or a Logic App) which can perform actions like scaling out a resource if there is a bottleneck (though some PaaS services offer this as a separate item, so be sure to plan accordingly).

Our action group will now email the Owner of the chosen resources (assuming the Owner has a valid email address).

## Create an Alert Rule

Now that you've established an Action Group for our alert, lets return to the `Monitor - Alerts` page and create a new alert rule.

1. click on the `Alerts` section, and `+New alert rule`
2. Under the Resource section, click `Select`
3. Under the Filter by resource type dropdown, choose All
4. Select the Application Gateway created earlier in the workshop
5. Under the Condition section, click `Add`
6. Select `Failed requests`
7. On the Configure signal logic blade, under `Dimension values` choose the backend created earlier from the dropdown list (there will only be one to choose)
8. Under Threshold, choose `Dynamic`

>**Dynamic Thresholds**
>
>Dynamic Thresholds use Machine Learning algorithms to understand the metric patterns for a given resource and calculate the thresholds automatically.

8. Leave the defaults for everything else.

>**Condition Preview**
>
>You can see how the condition will evaluate using the Condition Preview description. The aggregated points can be adjusted in the Advanced settings but for Dynamic Thresholds its best to leave the defaults for the initial alert.

9. Under the Actions Groups (optional) section, click `Add`
10. Choose the Action Group created at the beginning of the exercise
11. Under Alert Details, for the `Alert rule name` paste the following: `Dynamic Failed Request Alert`
12. For the description paste: `Alert whenever the failed requests of the application gateway is greater or less than the dynamic thresholds.`
13. Change the Severity to Sev 1
14. Click `Create alert rule` at the bottom of the page

Congrats! You just completed setting up your first dynamic alert based on diagnostic metrics. But this is only one part of the puzzle. In the next module we're going to add to our monitoring by getting deep insights at the application layer. Taken together, these monitoring solutions really should inform iterative improvements for both the infrastructure and application layers of our DevOps solution.