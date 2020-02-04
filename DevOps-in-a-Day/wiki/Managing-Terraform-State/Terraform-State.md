# Terraform State 

Up until now, you've been using Terraform to deploy resources from the command line by running `terraform apply`. You may have noticed that a `terraform.tfstate` file was created and updated each time you ran Terraform. What's up with that file?

That file is called a Terraform state file, but what's it for?

Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata (like resource ids, names, etc.), and to improve performance for large infrastructures.

## Why state files are important

Imagine you're trying to create a virtual machine using Terraform, and the first time you run `terraform apply`, a VM is created and named `myVM`. Now, you update your Terraform code, adding another resource, then re-run *terraform apply*. Now, imagine that Terraform doesn't know anything about the environment it's deploying to. What should it do? Create a new VM named `myVM`? Update the existing VM? How does it know that VM already exists, and how does it know that VM is the same VM you referenced in your code?    

Terraform answers these questions by keeping a cached environment configuration within a file - the state file. When `terraform apply` is run, it examines the state file, and reads the environment configuration, then determines whether it will create, update, or delete resources. Even though Terraform can query the destination environment to see if resources exist, and create a plan from the *live* information, it's much faster to cache the environment state and work from it locally. 

There are other benefits from managing state in a local file, but we're not going to cover those in today's workshop. 

## State file specifics

Terraform state is stored (by default) in a local file named `terraform.tfstate`, but it can also be stored remotely, which works better in a team environment. In fact, when you integrate Terraform into a build and release pipeline (like we will do later in our workshop), you need to store state files in a central location. 
