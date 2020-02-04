# Securing your Web App with a WAF/Application Gateway

In this chapter, we will be extending our existing web app infrastructure to include a layer of networking and security. We will be adding two new modules that integrate into what has been deployed already. This includes an Azure App Gateway resource.

> **What is a WAF/Application Gateway?**
>
> An Azure Application Gateway is a managed Layer 7 Firewall service provided by Microsoft. This solution is sometimes referred to as a WAF or Web Application Firewall, and in fact, has a WAF mode which includes additional features such as protection against SQL Injections and other common attacks. The App Gateway is a powerful tool which gives us URL routing capabilities, enterprise-level network security and can integrate with other Azure services, including Azure Web Apps.

## Create Supporting Modules

In addition to the App Gateway, we have some other network resources which will be deployed. This includes an Azure Virtual Network, Subnets, and a Public IP which will be used for the App Gateway. 

> **Virtual Networks, Subnets, Public IPs**
>
> The Virtual Network is a unique private address space which contains one or more subnets that can be used for internal, isolated routing. Some PaaS services in Azure can be integrated with Virtual Networks for private communication, including App Services. Subnets are a way to carve up the address space and further isolate resources on the private network. Public IPs are resources in Azure which can be attached to services like the Application Gateway to provide a single entrypoint for web applications.
