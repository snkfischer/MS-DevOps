# Exercise: Provisioning a workshop VM in your Azure Subscription

Navigate to the [Azure portal](https://portal.azure.come), then click the *Cloud Shell* link at the top:

![](/.attachments/images/introduction/cloud-shell.png)

When the Cloud Shell opens, it will look similar to the terminal shown below:

![](/.attachments/images/introduction/cloud-shell-3.png)

Before continuing, ensure "Bash" is selected in the upper-left corner of the cloud shell (as shown above)

Using the Bash Cloud Shell, run this command to create your workshop VM (copy and paste into the cloud shell):

```bash
[ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master;curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/devops-in-a-day-workshop; chmod +x build.sh; ./build.sh
```

![](/.attachments/images/introduction/create-vm.png)

Wait for the script to finish (it takes ~10 minutes).

## Connecting to the Virtual Machine

When the script is finished running, your VM will be ready! You'll find the VM in a resource group within the Azure Portal. The VM will be named `tf-az-workshop-vm`. 

You can locate the virtual machine by locating your resource group. Click on the hamburger bar on the upper left of the Azure Portal:

![](/.attachments/images/introduction/hamburger.png)

Select the "Resource groups" option:

![](/.attachments/images/introduction/rgs.png)

Click on your resource group (there should only be 1, and it will be named `az-workshop-user###-rg`, where ### will match your user number assigned for the workshop:

![](/.attachments/images/introduction/rgs2.png)
 
Inside of the resource group, you'll see your virtual machine named `tf-az-workshop-vm`.

Click the `Connect` button:

![](/.attachments/images/introduction/connect.png)

On the panel that appears from the right, click the `Download RDP File` button:

![](/.attachments/images/introduction/connect2.png)

An RDP file will download in your browser. Double-click the file to open it, which will connect you to the virtual machine.

When prompted, enter the username and password for the VM:
- username: workshopadmin
- password: P.$$w0rd1234

That's it for the pre-requisites for today's workshop sit back and relax - we'll be getting started soon!

_This concludes the exercise._