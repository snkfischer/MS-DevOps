# Exercise: Building an App

Now that you have the infrastructure deployed, it's time to turn your attention back to the Web App you looked at earlier.

## Updating the Build Pipeline

Return to your Pipeline in Azure DevOps and edit it.

Add a new Agent Job to the pipeline. Name it `Build Web`:

![](/.attachments/images/Creating-CICD-Pipelines/pipeline10.png)

### Add a .NET Core Build Task

Add a `.NET Core` task to the job:

![](/.attachments/images/Creating-CICD-Pipelines/pipeline11.png)

Configure it with these values:
- Display name: dotnet build
- Command: build
- Arguments: --configuration Release 
- Path to projects: src/**/*.csproj

### Add a .NET Core Publish Task

Add another `.NET Core` task to the job:

Configure it with these values:
- Display name: dotnet publish
- Command: publish
- Publish Web Projects: checked
- Arguments: --configuration Release --output $(Build.ArtifactStagingDirectory)/web 
- Zip published projects: checked
- Add project's folder name to publish path: checked

### Add a Publish Pipeline Artifacts Task

Add a `Publish pipeline artifacts` task to the job and configure it:

- Display name: Publish Pipeline Artifact: web
- File or directory path: $(Build.ArtifactStagingDirectory)/web
- Artifact name: web
- Artifact Publish Location: Azure Pipelines

### Test the build

Save and queue your build. Monitor the logs and ensure you have a web artifact that is produced from the build. Inspect the web artifact and you'll see it has a zip file inside:

![](/.attachments/images/Creating-CICD-Pipelines/pipeline12.png)

That's it! You've created a generalized build of an ASP.NET website. Next step use the artifact to deploy it to our newly-created Azure infrastructure.
