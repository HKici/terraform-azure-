resource "azurerm_subnet" "fw_hub_sub" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_public_ip" "fw_pub_ip" {
  name                = "fw-pub-ip"
  location            = local.location
  resource_group_name = local.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub_fw" {
  name                = "hub-fw"
  location            = local.location
  resource_group_name = local.resource_group
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.fw_hub_sub.id
    public_ip_address_id = azurerm_public_ip.fw_pub_ip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "fw_net_rule" {
    name= "allow-inter-vnet-trafic"
    azure_firewall_name = azurerm_firewall.hub_fw.name
    resource_group_name = local.resource_group
    priority = 200
    action = "Allow"

    rule {
      name = "Allow-Trafic-10.0.0.0-to-10.1.0.0"
      protocols = ["Any"]
      source_addresses = ["10.0.0.0/16"]
      destination_addresses = ["10.1.0.0/16"]
      destination_ports = ["*"]
    }

    rule {
      name = "Allow-Trafic-10.1.0.0-to-10.0.0.0"
      protocols = ["Any"]
      source_addresses = ["10.1.0.0/16"]
      destination_addresses = ["10.0.0.0/16"]
      destination_ports = ["*"]
    }

      rule {
      name = "Allow-Internet"
      protocols = ["Any"]
      source_addresses = ["Any"]
      destination_addresses = ["Any"]
      destination_ports = ["*"]
    }
}


