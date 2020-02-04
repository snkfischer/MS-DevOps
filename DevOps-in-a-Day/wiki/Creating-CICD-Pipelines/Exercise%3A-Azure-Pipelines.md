# Exercise: Azure Pipelines

Start by logging into your Azure DevOps project. Navigate to the Azure DevOps URL we included on your information sheet. Your URL will look like https://dev.azure.com/...

Use the account provided to you to login. 

Navigate to the Pipelines area:

![](/.attachments/images/Creating-CICD-Pipelines/pipeline1.png)

## Create the pipeline

Create a new Pipeline by clicking the `Create Pipeline` button. 

At first, you'll be asked "Where's your code?". On this screen, scroll to the bottom and click the link that reads, **"Use the classic editor to create a pipeline without YAML."**

![](/.attachments/images/Creating-CICD-Pipelines/pipeline2.png)

> **What's the difference between YAML and the classic editor? **
>
> The classic editor uses a GUI interface to quickly create pipelines. YAML builds give you a coding-like experience. Both system have near-feature-parity. Depending on your background and previous usage of CICD pipeline technologies, you may prefere one over the other. It's up to you, but today you'll be using the classic editor.

In the classic editor, select *Azure Repos Git* as your repository and these settings:

    - Team Project: ProjectX, where X is your user number
    - Repository: ProjectX, where X is your user number
    - Branch: master

![](/.attachments/images/Creating-CICD-Pipelines/pipeline3.png)

Click `Continue`.

## Choose the pipeline template

On the *Select a template* screen, click the *Empty job* link. Now you're ready to create your build pipeline.

> **What is a pipeline?** 
>
> A pipeline is (in simple terms) a fancy task runner. Pipelines are organized into a series of 1 or more jobs. Jobs then have a series of tasks that are run in sequence, on after the other. In this exercise, you'll be create a job with several tasks to collect the Terraform source code and publish it as an artifact. Later, we'll use the artifact to deploy to dev and prod environments.

Click on `Agent job 1`, rename it to `Build Terraform`:

![](/.attachments/images/Creating-CICD-Pipelines/pipeline4.png)

## Configure a Copy Files task

Add and configure a `Copy files` task to stage the Terraform code to be uploaded as an Artifact.

Click the *+* sign next to the `Build Terraform` job to add a `Copy files` task.

![](/.attachments/images/Creating-CICD-Pipelines/pipeline5.png)

Find the `Copy files` task and add it. You can search for it, or find it under the `Utility` category.

![](/.attachments/images/Creating-CICD-Pipelines/pipeline6.png)

When it's added to your pipeline, click on the task and configure it with these values:

- Display Name: Copy Files to: Staging Directory
- Source folder: terraform
- Contents: **
- Target Folder: $(Build.ArtifactStagingDirectory)/terraform

> $(Build.ArtifactStagingDirectory) is a reserved pipeline variable that holds the full path of a special folder on the pipeline server's file system where artifacts should be staged. It's reserved for this specific purpose, so it's safe to copy files we want to upload as artifacts to this location.

## Configure a Publish Pipeline Artifacts task

Add and configure a `Publish Pipeline Artifact` task to upload the staging files as an artifact. Find and add the `Publish Pipeline Artifact` task in the `Utility` category.

Configure the task with these values:

- Display Name: Publish Pipeline Artifact: terraform
- Path to Publish: $(Build.ArtifactStagingDirectory)/terraform
- Artifact name: terraform
- Artifact publish location: Azure Pipelines

> The artifact name is a special value that we'll use later to reference the collection of files we're uploading as an artifact. 

## Testing your Pipeline

Click the `Save & Queue` button at top to save the pipeline and queue it for execution. 

On the `Run Pipeline` screen, select the following:

- Agent pool: Azure Pipelines
- Agent specification: windows-2019
- Branch/tag: master

Click `Save & Run`. This will queue pipeline tasks for execution.

After queueing the build, you can monitor it's progress on the screen. Explore the UI by clicking on tasks as they execute - you'll see the command line/terminal output of each command logged and streaming to the screen. 

![](/.attachments/images/Creating-CICD-Pipelines/pipeline7.png)

After ~30 seconds, the pipeline should succeed. At the top right, there is an `Artifacts` area. Click on the `1 published` message and review the contents of the `terraform` artifact. It should contain the contents of the `terraform` source control folder.

![](/.attachments/images/Creating-CICD-Pipelines/pipeline8.png)

![](/.attachments/images/Creating-CICD-Pipelines/pipeline9.png)

That's it! 