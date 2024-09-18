# A simple hub and spoke network provisioned with Terraform

The code provisions the following Azure resources:

- A ressource Group

- A hub network
	- Subnet for Hosts
	- Subnet for Azure-Firewall

- Two spoke networks
	- Subnet for the Hosts
	- Peering between spoke and hub network

- In each Network a debian VM for connectivity testing

- one routing table per spoke network to manage connectivity between spoke and hub network

- An Azure-firewall inside the hub network, to manage the routes between the spoke networks
	- appropriate FW-rules
	

To use this code you have to implement the provider with your credentials or better create an app-regestration and assign the appropriate Entra-ID rolls.
