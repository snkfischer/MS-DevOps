# Exercise: Automating Infrastructure Deployments

In this section, you'll be using the Terraform build artifact to create a release pipeline to deploy to dev and prod environments.

## Before you Begin

You'll recall you  added a terraform backend configuration to the `dev/main.tf` and `prod/main.tf` files in a previous section. Hard-coding this information works OK when you're working alone, but when you're automating with Terraform, you shoudln't hard-code this information.

Before you beign building out a pipeline, replace the backend configurations with the following in `dev/main.tf` and `prod/main.tf`:

```
terraform {
  backend "azurerm" { }
}
```

Don't forgot to commit and push your changes! 

## Create a release pipeline

Start by navigating to the Pipelines -> Releases area:

![](/.attachments/images/Creating-CICD-Pipelines/release1.png)

Create a new release pipeline by clicking `New pipeline`.

Click the `Empty Job` template button to create an empty pipeline:

![](/.attachments/images/Creating-CICD-Pipelines/release2.png)

## Create a Dev Stage

Change the name of `Stage 1` to `Dev`, then click the `X` in the upper corner to close the stage details:

![](/.attachments/images/Creating-CICD-Pipelines/release3.png)

## Configure Artifacts

Click the `+ Add` button next to `Artifacts` to add an artifact. Configure it:

- Source type: Build
- Project: ProjectX, where X is your user number
- Source (build pipeline): ProjectC-CI
- Default version: Latest
- Source alias: _ProjectX-CI

## Add Release Tasks

Click the `1 job, 0 task` link under the `Dev` Stage to begin adding jobs and tasks to the release pipeline:

![](/.attachments/images/Creating-CICD-Pipelines/release4.png)

> Release pipelines are like build pipelines, as they have Jobs and Tasks. But, they introduce another component: stages. For now, you can think of stages as a concept akin to an environment - so each environment you deploy to will have a stage: dev stage and prod stage. 
>
> Stages also come with automation and approvals, so it's possible to automatically start a stage when a new artifact is available (or when a build completes) or when another stage completes (for example, starting a prod stage deployment when the dev stage completes). You can also gate a stage execution with a robust approval chain.   
>
> Having a single stage per environment makes a lot of sense, but in more complex environments multi-stage-per-environment releases may be advantageous. In general, we start with a stage per environment, typically.

Click on `Agent Job` and rename it to `Deploy Infrastructure`:

![](/.attachments/images/Creating-CICD-Pipelines/release5.png)

### Adding Terraform Tool Installer task

Add a `Terraform tool installer` task to the job. You can search for task in the search bar of the task interface:

![](/.attachments/images/Creating-CICD-Pipelines/release6.png)

Using this task allows you to install a specific version of the Terrform tools into your release pipeline. 

Change the following properties:
- Display name: Install Terraform 0.12.20
- Version: 0.12.20

### Adding the Terraform init task

Next, add the *Terraform* task to pipeline:

![](/.attachments/images/Creating-CICD-Pipelines/release7.png)

Configure it with these parameters:

    - Display name: Terraform: init
    - Provider: azurerm
    - Command: init
    - Configuration directory: Use the file browser dialog to locate the terraform/dev folder within your linked build artifact
    - Azure Subscription: Open drop-down and use `Azure Subscription` under `Available Azure service connections`
    - Resource group: az-workshop-userX-rg
    - Storage account: workshopuserXXXXXX
    - Container: dev
    - Key: terraform.tfstate (the name of your state file)

### Adding the Terraform apply task

Add a second `Terraform` task to pipeline and configure it:

    - Display name: Terraform: apply
    - Provider: azurerm
    - Command: validate and apply
    - Configuration directory: Use the file browser dialog to locate the terraform/dev folder within your linked build artifact
    - Azure Subscription: Open drop-down and use `Azure Subscription` under `Available Azure service connections`

Save the pipeline.

### Testing the release

Create a release and deploy to the Dev stage. Just as you did with the build, you can monitor the pipeline. Ensure it succeeds (it may take a few minutes).  

## Adding a prod stage

After validating the release pipeline created the resources you were expecting, it's time to create a prod stage of the pipeline.

Clone the Dev stage of the pipeline to create a Prod stage. Click the Pipeline menu at top, then the `Clone` button underneath the `Dev` stage:

![](/.attachments/images/Creating-CICD-Pipelines/release8.png)

Rename the `Copy of Dev` stage to `Prod`.

Adjust these settings in the Prod stage tasks:

- For the init task, change the configuration directory to the `terraform/prod` directory
- For the init task, change the storage account container to `prod`
- For the apply task, change the configuration directory to the `terraform/prod` directory

### Testing the prod stage

Save and queue the pipeline again. Validate it runs the pipeline, executing the Dev stage, then the Prod stage.

Congrats! You just created an infra-as-code CICD pipeline. 
