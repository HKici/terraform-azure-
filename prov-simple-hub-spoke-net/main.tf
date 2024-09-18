
locals {
  resource_group = "hub-and-spoke"
  location       = "North Europe"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group
  location = local.location
}

# Peering dev-to-hub & hub-to-dev
resource "azurerm_virtual_network_peering" "dev_to_hub_peer" {
  name                         = "dev-to-hub-peer"
  virtual_network_name         = azurerm_virtual_network.devnetwork.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnetwork.id
  resource_group_name          = local.resource_group
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_dev_peer" {
  name                         = "hub-to-dev-peer"
  virtual_network_name         = azurerm_virtual_network.hubnetwork.name
  remote_virtual_network_id    = azurerm_virtual_network.devnetwork.id
  resource_group_name          = local.resource_group
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering test-to-hub & hub-to-test
resource "azurerm_virtual_network_peering" "test_to_hub_peer" {
  name                         = "test-to-hub-peer"
  virtual_network_name         = azurerm_virtual_network.testnetwork.name
  remote_virtual_network_id    = azurerm_virtual_network.hubnetwork.id
  resource_group_name          = local.resource_group
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_test_peer" {
  name                         = "hub-to-test-peer"
  virtual_network_name         = azurerm_virtual_network.hubnetwork.name
  remote_virtual_network_id    = azurerm_virtual_network.testnetwork.id
  resource_group_name          = local.resource_group
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
