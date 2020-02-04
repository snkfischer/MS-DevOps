# Configure Git

Before we continue, there is a one-time step for configuring Git.  We must configure Git to recognize our name and e-mail address.  Git stores this information with each commit.

Inside of Visual Studio Code, open a Terminal by selecting **New Terminal** from the **Terminal** menu.

When the terminal window opens, copy the command below and paste it into the terminal, substituting your name, or the workshop user you were assigned (for example, "User 1").

```
git config --global user.name "replace_with_your_name"
```

Next, copy the command below and past it into the terminal, subtituting the e-mail address assigned to you for the workshop.

```
git config --global user.email "replace_with_your_email_address"
```

Git is now configured with your name and e-mail address and will use it when you commit changes to the repository.