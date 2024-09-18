# A simple hub and spoke network provisioned with Terraform

The code provisions the following Azure resources:

- A ressource Group

- A hub network
	- Subnet for Hosts
	- Subnet for Azure-Firewall

- Two spoke networks (dev and test)
	- Subnet for the hosts
	- Peering between spoke and hub network

- In each Network a debian VM for connectivity testing

- One routing table per spoke network to manage connectivity between spoke and hub network

- An Azure-firewall inside the hub network, to manage the routes between the spoke networks
	- appropriate FW-rules
	

