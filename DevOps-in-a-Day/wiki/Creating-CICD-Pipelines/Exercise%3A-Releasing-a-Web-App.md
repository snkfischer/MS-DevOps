# Exercise: Releasing a Web App

In this section, you'll be updating the Dev and Prod release stages by adding a job and tasks to deploy the web artifact to the Azure environments created by your Terraform deployment. Hop to it.

Edit the release pipeline you created earlier.

## Update Dev

Open the Dev stage tasks, add a *New agent job*, name it `Deploy Web`.

Add a `Azure App Service Deploy` task and configure:

- Display name: Azure App Service Deploy: web
- Connection Type: Azure Resource Manager
- Azure subscription: Select `Azure Subscription` under `Available Azure service connections`
- Azure Service Type: Web App on Windows
- App Service Name: select the dev app server Terraform deployed
- Package or folder: browse to the ContosoUniversity.zip file
- Expand File Transforms & Variable Substitution Options
    - JSON variable substitution: appSettings.json

## Update Prod

Update the Prod stage in the same way, but take care to use the Prod web app. 

Save your pipeline.

## Add Variables

The final and most important step in the release pipeline is to add variables that will be injected (or replaced) in the appSettings.json file when it's deployed.

You'll recall that you supplied `appSettings.json` as a file to transform at deployment time. To substitute JSON variables that are nested or hierarchical, specify them using JSONPath expressions.

For example, to replace the value of DefaultConnection in the sample below, you need to define a variable as `ConnectionStrings.DefaultConnection` in the release pipeline (or release pipeline's environment).
{
    "ConnectionStrings": {
        "DefaultConnection": "Server=(localdb)\SQLEXPRESS;Database=MyDB;Trusted_Connection=True"
    }
}

So, you can now easily specify the Dev and Prod SQL database connections strings by adding a Release Variable named `ConnectionStrings.DefaultConnection`.

Click the `Variables` tab at the top of the release pipeline, then create 2 variables named `ConnectionStrings.DefaultConnection`. Scope one variable the `Dev` and the other to `Prod`. For the `Dev` variable, enter the development environment's SQL Server connection string. Do the same for production.

Now when the Dev stage runs, it will replace the connection string with the value of the Dev-scope variable at deployment time.

Pretty nifty.

## Testing

Save the pipeline and queue a release.

Navigate to the Azure portal and test both sites. 

_This concludes the exercise and this section._