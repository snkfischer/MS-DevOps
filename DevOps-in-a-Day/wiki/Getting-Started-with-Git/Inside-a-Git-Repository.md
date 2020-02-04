# Inside a Git Repository

Although not required, most Git repositories include a pair of files, namely the *.gitignore* and *README.md* files.  As a matter of fact, when creating a new repository, Azure DevOps offers to add both the .gitignore and README.md files for you.

## .gitignore

The .gitignore file is used to indicate to Git that it should ignore certain files and/or folders in the repository.  There are times when certain files or folders should not be included in the repository, such as build artifacts, dependency packages, log files, personal configuration files, etc.

Often, contents of the .gitignore file are similar based on the technology stack that you might be using.  For example, a Git repositories containing .NET projects will likely have very common, if not identical .gitignore files.  Azure DevOps simplifies creating a .gitignore file by allowing you to select from a list of common technology stacks and auto-generate the .gitignore file.

Additionally, you can use [gitignore.io](http://gitignore.io/) to help generate .gitignore files, even files which may contain multiple technology stacks.

Our .gitignore file contains patters to ignore common files when using Terraform, Visual Studio, and Visual Studio Code.  A snippet of the .gitignore file is below.

```
### Terraform ###
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Ignore any .tfvars files that are generated automatically for each Terraform run. Most
# .tfvars files are managed as part of configuration and so should be included in
# version control.
#
# example.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*
```

Visit https://git-scm.com/docs/gitignore to learn about the syntax of .gitignore files.

## README.md

It is common for a Git repository to contain a README.md file to help give context to team members who are using the repository.  Common information that is included in a README file may contain the maintainer's contact details, helpful information about how to build the source, acceptable coding standards for the team, etc.

README files utilize the Markdown format.  Markdown is a lightweight markup language which allows you to write easy to read documentation in plain text, which is then converted to HTML when displayed.  To learn more about Markdown, you may visit the following list of references:

- [Daring Fireball: Markdown](https://daringfireball.net/projects/markdown/)
- [Markdown Guide](https://www.markdownguide.org/)

Often times, Git hosting platforms (such as Azure DevOps, Bitbucket, Github, etc.) will display your README.md file on the page with your repository making it easy to see your documentation alongside of your source code.

## .git Folder

> Beware: [Here be dragons!](https://en.wikipedia.org/wiki/Here_be_dragons)

When a new Git repository is initialized, or an existing Git repository is cloned from a remote location, a hidden folder named *.git* is created inside of the repository.  The .git folder contains all of the internals for the repository, including the history.

While there are times when it is necessary to access the .git folder, it is not recommended, and we will not require access for the purpose of this workshop.