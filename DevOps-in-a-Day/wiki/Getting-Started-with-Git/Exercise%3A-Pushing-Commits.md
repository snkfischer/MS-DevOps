# Exercise: Pushing Commits

When changes are committed to a Git repository, those changes are only committed to the <u>local</u> repository.  Recall, that you cloned your local repository from Azure DevOps.  Cloned repositories are simply your copy of the remote repository.  Now that we have committed changes to our local repository, how can we share our changes with the rest of the team?

The status bar in Visual Studio Code indicates that your local repository is 1 commit ahead of the remote.  The status bar illustrates the number of commits behind (ready to pull down from the remote), and ahead (ready to push up to the remote).

![Pushing Commits 1](/.attachments/images/Getting-Started-with-Git/Pushing-Commits-1.png)

To synchronize your local repository with the remote repository, simply click this area in the status bar inside of Visual Studio Code.

Visual Studio Code will prompt you telling you that you are about to push and pull commits to and from 'origin/master'.  Click **OK**.  

![Pushing Commits 2](/.attachments/images/Getting-Started-with-Git/Pushing-Commits-2.png)

Once your local repository has been synced, you will notice that the status bar no longer indicates that your local repository is ahead or behind the remote repository.

![Pushing Commits 3](/.attachments/images/Getting-Started-with-Git/Pushing-Commits-3.png)

In your web browser, refresh the Files view of your repository, and you should see that your change has been pushed.

![Pushing Commits 4](/.attachments/images/Getting-Started-with-Git/Pushing-Commits-4.png)

Congratulations!  You have now pushed your local commits to the remote repository and shared them with your team!

## Next Steps

There's a lot more to learn about version control systems (and Git), but we don't have time to cover it today. We'll continue to use the repository you cloned throuhg the workshop, so you'll get to practice committing and pushing changes.

In the next section, you'll begin learning about infrastructure as code, so read on!