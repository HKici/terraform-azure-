terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

}

locals {
  env = "development"

}

resource "azurerm_resource_group" "hk-rg" {
  name     = "hk-ressources"
  location = "Germany West Central"
  tags = {
    environment = local.env
  }
}

resource "azurerm_virtual_network" "hk-vn" {
  name                = "hk-network"
  resource_group_name = azurerm_resource_group.hk-rg.name
  location            = azurerm_resource_group.hk-rg.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    environment = local.env
  }

}

resource "azurerm_subnet" "hk-subnet" {
  name                 = "hk-subnet"
  resource_group_name  = azurerm_resource_group.hk-rg.name
  virtual_network_name = azurerm_virtual_network.hk-vn.name
  address_prefixes     = ["10.10.1.0/24"]

}

resource "azurerm_network_security_group" "hk-sg" {
  name                = "hk-sg"
  location            = azurerm_resource_group.hk-rg.location
  resource_group_name = azurerm_resource_group.hk-rg.name

  tags = {
    environment = local.env
  }

}

resource "azurerm_network_security_rule" "hk-dev-rule" {

  name                       = "hk-dev-rule"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.hk-rg.name
  network_security_group_name = azurerm_network_security_group.hk-sg.name
}

resource "azurerm_subnet_network_security_group_association" "hk-sga" {
  subnet_id                 = azurerm_subnet.hk-subnet.id
  network_security_group_id = azurerm_network_security_group.hk-sg.id

}

resource "azurerm_public_ip" "hk-ip" {
  name                = "hk-ip"
  resource_group_name = azurerm_resource_group.hk-rg.name
  location            = azurerm_resource_group.hk-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = local.env
  }
}

resource "azurerm_network_interface" "hk-nic" {
  name                = "hk-nic"
  location            = azurerm_resource_group.hk-rg.location
  resource_group_name = azurerm_resource_group.hk-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hk-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hk-ip.id
  }

  tags = {
    environment = local.env
  }
}

resource "azurerm_linux_virtual_machine" "hk-vm" {
  name                  = "hk-vm"
  resource_group_name   = azurerm_resource_group.hk-rg.name
  location              = azurerm_resource_group.hk-rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.hk-nic.id]

  custom_data = filebase64("customdata.tpl")


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/hkazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
        hostname = self.public_ip_address,
        user = "adminuser",
        identityfile = "~/.ssh/hkazurekey"

    })
    interpreter = [ "bash", "-c" ]
    
  }
}

data "azurerm_public_ip" "hk-ip-date" {
    name = azurerm_public_ip.hk-ip.name
    resource_group_name = azurerm_resource_group.hk-rg.name
  
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.hk-vm.name}: ${data.azurerm_public_ip.hk-ip-date.ip_address}"
}

/*
locals {
	rg_names = [
		"RG-NameList01",
		"RG-NameList02",
		"RG-NameList03",
]
}

resource "azurerm_resource_group" "rg_list" {
	for_each = toset(local.rg_names)
		name = each.value
		location = "West Europe"
}
*/