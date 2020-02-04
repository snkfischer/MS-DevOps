# Exercise: Add Application Insights to Web Apps

To install Application Insights to the Contoso University web app, open a `Terminal` in Visual Studio Code. Change to the `src` directory:

```
cd src
```

Run the install command to install Application Insights:

```
dotnet add .\ContosoUniversity\ContosoUniversity.csproj package Microsoft.ApplicationInsights.AspNetCore --version 2.7.1
```

## Update the Startup.cs file

Locate the Startup.cs source code file within the ContosoUniversity project. Replace the existing `ConfigureServices` function with the following (lines 26-40), which initializes Application Insights when the web app starts up:

```c#
// This method gets called by the runtime. Use this method to add services to the container.
public void ConfigureServices(IServiceCollection services)
{
  services.Configure<CookiePolicyOptions>(options =>
  {
    // This lambda determines whether user consent for non-essential cookies is needed for a given request.
    options.CheckConsentNeeded = context => true;
    options.MinimumSameSitePolicy = SameSiteMode.None;
  });

  // The following line enables Application Insights telemetry collection.
  services.AddApplicationInsightsTelemetry();

  services.AddDbContext<SchoolContext>(options =>
    options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));

  services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
}
```

## Update the appSettings.json file

Next, locate the `appSettings.json` file and replace its contents with the following (which adds the Application Insights Instrumentation Key to the file). Leave the key empty for now, you'll add it as a value in your Release Pipeline later.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=ContosoUniversity3;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "ApplicationInsights": {
    "InstrumentationKey": ""
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

Commit and push your code to the remote repository. Queue a build. While the build is running, move on to the next step.

## Updating the Release Pipeline

Edit the Release Pipeline you created previously, adding 2 new variables:

- ApplicationInsights.InstrumentationKey: value from the dev App Insights resource (scoped to Dev
- ApplicationInsights.InstrumentationKey: value from the prod App Insights resource (scoped to Prod)

Wait for the build to complete, if it hasn't already.

Save and queue the Release Pipeline.

## Testing Application Insights

After the updated code has deployed, visit the dev and prod web sites and click various links. After ~2 minutes, explore the Application Insights resources in the Azure Portal.

Application performance information will begin to flow into the Azure Portal. 

We don't have time to dive deep into Application Insights further. If you're interested in more details, check out the [official documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).