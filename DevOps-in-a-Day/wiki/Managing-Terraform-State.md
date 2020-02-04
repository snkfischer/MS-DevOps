# Managing Terraform State

In the last section, you had to delete Azure resources before redeploying with Terraform. Deleting resources is ok in a workshop, but it's not going to fly in production -- imagine that you had to delete your production database everytime you wanted to deploy Terraform. Ridiculous. Luckily, Terraform provides you with a way to manage this mischief.

In this chapter, you'll learn:
- the importance of Terraform state files
- what a Terraform backend is
- how to store and organize state files