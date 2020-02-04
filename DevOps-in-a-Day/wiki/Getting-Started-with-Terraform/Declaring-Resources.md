# Declaring Resources

Terraform is a declarative language, meaning it describes an intended goal (or end-state) of an environment, rather than the steps to reach the goal (or end-state).

This means that when your Terraform code is executed, Terraform will dynamically determine the steps it needs to take to bring your target environment in-line with your code. For example, assume your code declares a virtual machine. When run against an environment where the virtual machine does not exist, Terraform will create that virtual machine. If it's run against an environment where the virtual machine already exists, it will either update the virtual machine (so it's configured according to your definition) or do nothing (because the virtual machine needs no changes).

Declarative infra-as-code (IaC) languages can be powerful, but sometimes the results an be unexpected if you don't understand how/why they work.

Enough talking - let's get declaring!