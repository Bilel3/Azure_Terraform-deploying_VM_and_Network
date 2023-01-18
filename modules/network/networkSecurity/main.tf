resource "azurerm_network_security_group" "nsg_tf" {
  name                = "SecurityGroup_tf"
  location            = var.resourceGroupLocation
  resource_group_name = var.resourceGroupName
  tags = {
    environment = "dev"
  }
}
resource "azurerm_network_security_rule" "nsr_tf" {
  name                        = "tf_dev_rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = var.resourceGroupName
  network_security_group_name = azurerm_network_security_group.nsg_tf.name
}
resource "azurerm_subnet_network_security_group_association" "ngs_association_tf" {
  subnet_id                 = var.subnetId
  network_security_group_id = azurerm_network_security_group.nsg_tf.id
}
