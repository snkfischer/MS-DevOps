## What is Terraform?

[Terraform](https://www.terraform.io/) is an open source tool Hashicorp that allows you to safely and predictably create, change, and improve infrastructure. It codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

With Terraform you can:
1. Write infrastructure as code
2. Plan changes to your infrastructure
3. Create reproducible infrastrcuture

### Write infrastructure as code

With Terraform, you define infrastructure as code to increase productivity and transparency. Your Terraform can be (and should be) stored in a version control system, shared, and collaborated on by a team. With this approach, you track the incremental changes and historical state of your infrastructure. And, by nature, the codification of the infrastructure is automation friendly, so it can sit inside of a CICD pipeline to dynamically deploy infrastructure, then the code that runs on the infrastructure.

### Plan changes to your infrastructure

Terraform provides an elegant user experience for teams to safely and predictably make changes to infrastructure. 

Teams can understand how a minor change could have potential cascading effects across an infrastructure before executing that change (through a Terraform process called a plan). Terraform builds a dependency graph from the configurations, and walks this graph to generate plans, refresh state, and more.

Terraform also separates the *plan* process discussed above from the *apply* process, which makes the changes to the infrastructure. Separating plans and applies reduces mistakes and uncertainty at scale. Plans show teams what would happen, applies execute changes.

Terraform also have a rich library of infrastructure *providers* (Azure, AWS, GCP, OpenStack, VMware, Hyper-V, and more), which allow you to make changes across multiple on-premises and cloud environments at the same time. 

### Create reproducible infrastructure

Terraform lets teams easily use the same configurations in multiple places to reduce mistakes and save time. You can use the same configuration files to deploy multiple identical environments. Common Terraform configurations (like SQL/IIS or LEAN/MEAN stack apps) can be packaged as modules and used across teams and organizations.

# Getting Started with Terraform

In this chapter, you'll deploy multiple services in Azure which will make up the base of your web application infrastructure: a Resource Group,an App Service Plan, and an App Service. In later chapters, you'll add to this by provisioning a SQL Azure Database (made up of an Azure SQL resource and an Azure SQL Database resource) and a Web Application Firewall.

## Terraform Providers

In the first section, you're going to start by creating your first code file and adding a provider.

> **What is a provider?**
>
> Providers tell Terraform what API it is interacting with for resource deployment. There are a number of officially supported Providers, as well as community-driven providers. The AzureRM Provider is one of the officially supported providers for Azure and the one we will be using throughout this workshop.

Let's jump right in.