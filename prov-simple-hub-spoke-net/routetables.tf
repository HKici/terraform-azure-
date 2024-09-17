# Route Table dev-route
resource "azurerm_route_table" "dev_route" {
  name                = "dev-route"
  location            = local.location
  resource_group_name = local.resource_group


  route {
    name                   = "route-to-test"
    address_prefix         = "10.1.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.2.1.4"
  }
}
resource "azurerm_subnet_route_table_association" "dev-ass" {
  subnet_id      = azurerm_subnet.devsub.id
  route_table_id = azurerm_route_table.dev_route.id
}
# Route Table test-route
resource "azurerm_route_table" "test_route" {
  name                = "test-route"
  location            = local.location
  resource_group_name = local.resource_group

  route {
    name                   = "route-to-dev"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.2.1.4"
  }
}

resource "azurerm_subnet_route_table_association" "test-ass" {
  subnet_id      = azurerm_subnet.testsub.id
  route_table_id = azurerm_route_table.test_route.id
}