resource "azurerm_virtual_network" "testnetwork" {
  name                = "test-network"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "testsub" {
  name                 = "test-subnet"
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.testnetwork.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_network_interface" "test_nic" {
  name                = "test-nic"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.testsub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test_vm" {
  name                = "test-vm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_B1s"
  admin_username      = "huso"
  admin_password      = "Huso!1207"
  network_interface_ids = [
    azurerm_network_interface.test_nic.id,
  ]

  admin_ssh_key {
    username   = "huso"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "Debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }
}