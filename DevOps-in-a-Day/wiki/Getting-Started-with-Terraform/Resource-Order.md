# Resource Order

The keen eye may have noticed we declared the Terraform resources in a specific order. Was that necesary? No. 

Terraform is smart, and when it runs against your declarative code, it reads the entire code file in, parses it, determines resource dependencies, and then creates/updates the infrastructure in the order determined by its dependency calculations. 

In other words, we could have added these resource code snippets in ANY order in the file, and Terraform will figure out the right way to order resources for proper deployment.

Let's deploy some resources!
