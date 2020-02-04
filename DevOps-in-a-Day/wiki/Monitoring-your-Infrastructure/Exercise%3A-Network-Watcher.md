# Exercise: Enabling Network Watcher

By default in Azure, virtual networks are deployed with Network Watcher enabled in the region where they're deployed. Network Watcher is a critical monitoring tool for obtaining traffic flow information about virtual networks, as well as monitoring and repairing the network health of IaaS products (like Virtual Machines, Application Gateways, Load Balancers, etc.). When we deploy virtual networks and these IaaS-based resources using Terraform, we will need to add Network Watcher manually (or in our code base).

Perform the following steps to see how to deploy Network Watcher:

1. Type in the Azure search bar at the top of the portal page: `network watcher`, Click on the Network Watcher resource
2. On the default Overview page that you land on, drill into the `regions`
3. Locate the region where resources were deployed (East US), then click the ... and choose `Enable network watcher` (this should already be enabled for you due to access restrictions in the workshop)

## Topology, Usage and Quotas, and Traffic Analytics

With Network Watcher enabled, navigate to **Topology** to see the Topology of the network. It should be minimal right now, but this can become an important visualization tool for your network as it grows. You can also click into each component (such as the subnet) in the visualization and it will take you to the resource page of that component.

The next section to note in Network Watcher is the `Usage + quotas` which provides an overview of the current subscription limits for various Network resources. If you are close to reaching a subscription limit, you can request an increase with the `Request Increase` button.

The last section to take note of here is Traffic Analytics. Traffic Analytics uses Log Analytics, which we have not setup in this module. But its important to note that this tool uses flow logs across Regions and Subscriptions in Azure to provide information about optimizing workload performance, among other features.
