# Creating a Build Pipeline

Up to this point, you've been deploying your infrastructure and code manually, but if you're seeking to adopt a DevOps approach to delivering solutions, automation is key. In this section, you'll learn how to build a CI/CD Pipeline in Azure DevOps. 

> **What is a CI/CD Pipeline?**
>
> CI/CD stands for continuous integration / continuous deployment. 
>
> Per Wikipedia, "continuous integration (CI) is the practice of merging all developers' working copies to a shared mainline (or branch)) several times a day." Continuous deployment is often coupled with continuous integration, and is the practice of having your software in a state that can always be deployed to an environment.
>
> Together, CI/CD pipelines are the practice of fully-automating the CI and CD tasks of software development. In general, this means automating the process of ensuring all developers are using a source control system, ensuring each commit to the source control system is built/compiled, testing the compiled code with automated tests during the build process, deploying the built/compiled code to an environment for testing and production.

Azure DevOps makes CI/CD Pipelines easy. Let's jump in!