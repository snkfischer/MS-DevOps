# Exercise: Storing State Remotely

In this section, you'll be updating your Terraform code to configure a backend. But, before we can do that, we'll need to locate your Azure storage account. 

> **To Terraform or not to Terraform?**
>
> This *IS* the question for backends. Now that you know of the importance of storing Terraform state files in a backend, should you use Terraform to create the backend store? To me, it doesn't matter. Typically, DevOps teams already have a preferred platform for data/artifact storage (like an Azure DevOps repository or Artifactory or a Storage Account). In this case, your backend exists already. If you're just jumping into Terraform, it's ok to manually create your backend data store - just remember, it should be backed up!

We've pre-created your storage account for you, so there's not a lot of work to do to find your storage account. Let's use the portal to get its name.

Login to the Azure Portal and click the hamburger bar, locate your resource group, and click into your resource group.

Within your resource group, you'll see the Storage Account we created for you:

![storage](\.attachments\images\Managing-Terraform-State\storage-account.png)

You account will NOT have the same name (because storage account names must be unique).

**Write down the name of your storage account.**

Click into the storage account and locate the "Containers" area. We'll be creating a storage container to hold our `dev` and `prod` state files. 

Click into the `Containers` area:

![containers](\.attachments\images\Managing-Terraform-State\containers.png)


Using the `+ Container` button and Azure Portal UI, create 2 containers: `dev` and `prod`. If prompted, the `Public access level` should be `Private`. When you're finished you should have both containers listed:

![containers](\.attachments\images\Managing-Terraform-State\containers2.png)

> **Organizing State Files**
>
> As you store your state files, it's important to organize them so you don't accidentally overwrite or lose it. We're using a simple naming scheme of `dev` and `prod` to store ours, but you may need something more sophisticated in the real world.

_This concludes the exercise._