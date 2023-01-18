resource "azurerm_public_ip" "public_ip_tf" {
  name                = "PublicIp_tf"
  resource_group_name = var.resourceGroupName
  location            = var.resourceGroupLocation
  allocation_method   = "Dynamic"
  tags = {
    environment = "dev"
  }
}
resource "azurerm_network_interface" "nic_tf" {
  name                = "network_inteface_tf"
  resource_group_name = var.resourceGroupName
  location            = var.resourceGroupLocation
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_tf.id
  }
  tags = {
    environment = "dev"
  }
}
