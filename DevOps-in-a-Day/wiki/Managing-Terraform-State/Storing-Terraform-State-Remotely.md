# Storing Terraform state remotely

Just like Terraform has providers for integrating with various platforms (Azure, AWS, VMWare, HyperV, etc.), it has providers to integrate with various *backends*.

> **What is a backend?**
>
> A *backend* in Terraform determines how state is loaded and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc. For example, a backend could be a Windows or Linux file share, an Azure or AWS storage account, or a repository, like Artifactory or Azure DevOps. 

By default, Terraform uses the "local" backend, which is the normal behavior of Terraform you're used to (this is what created the terraform.tfstate files previously). 

Here are some of the benefits of backends:

1. Working in a team: Backends can store their state remotely and protect that state with locks to prevent corruption. Some backends such as Terraform Cloud even automatically store a history of all state revisions.

2. Keeping sensitive information off disk: State is retrieved from backends on demand and only stored in memory. If you're using a backend such as Azure storage accounts, the only location the state ever is persisted is in the storage account.

3. Remote operations: For larger infrastructures or certain changes, terraform apply can take a long, long time. Some backends support remote operations which enable the operation to execute remotely. You can then turn off your computer and your operation will still complete. Paired with remote state storage and locking above, this also helps in team environments.

Backends are completely optional. You can successfully use Terraform without ever having to learn or use backends. However, they do solve pain points that afflict teams at a certain scale. If you're working as an individual, you can likely get away with never using backends.

> **Will we be using a backend in the workshop?**
>
> Yes. In this workshop, you'll be using an Azure storage account as the backend. 

OK, enough talking. Let's start doing.