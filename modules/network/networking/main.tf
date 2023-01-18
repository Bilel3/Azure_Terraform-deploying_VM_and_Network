# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Vnetwork_tf" {
  name                = "tf_VNetwork"
  resource_group_name = var.resourceGroupName
  location            = var.resourceGroupLocation
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet_tf" {
  name                 = "subnet-tf-test"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.Vnetwork_tf.name
  address_prefixes     = ["10.123.1.0/24"]
}