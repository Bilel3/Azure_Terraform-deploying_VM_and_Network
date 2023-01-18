terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "testing_tf" {
  name     = "testing_terraform"
  location = "West Europe"
  tags = {
    environment = var.environment
  }
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Vnetwork_tf" {
  name                = "tf_VNetwork"
  resource_group_name = azurerm_resource_group.testing_tf.name
  location            = azurerm_resource_group.testing_tf.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "subnet_tf" {
  name                 = "subnet-tf-test"
  resource_group_name  = azurerm_resource_group.testing_tf.name
  virtual_network_name = azurerm_virtual_network.Vnetwork_tf.name
  address_prefixes     = ["10.123.1.0/24"]
}
resource "azurerm_network_security_group" "nsg_tf" {
  name                = "SecurityGroup_tf"
  location            = azurerm_resource_group.testing_tf.location
  resource_group_name = azurerm_resource_group.testing_tf.name
  tags = {
    environment = var.environment
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
  resource_group_name         = azurerm_resource_group.testing_tf.name
  network_security_group_name = azurerm_network_security_group.nsg_tf.name
}
resource "azurerm_subnet_network_security_group_association" "ngs_association_tf" {
  subnet_id                 = azurerm_subnet.subnet_tf.id
  network_security_group_id = azurerm_network_security_group.nsg_tf.id
}
resource "azurerm_public_ip" "public_ip_tf" {
  name                = "PublicIp_tf"
  resource_group_name = azurerm_resource_group.testing_tf.name
  location            = azurerm_resource_group.testing_tf.location
  allocation_method   = "Dynamic"
  tags = {
    environment = var.environment
  }
}
resource "azurerm_network_interface" "nic_tf" {
  name                = "network_inteface_tf"
  location            = azurerm_resource_group.testing_tf.location
  resource_group_name = azurerm_resource_group.testing_tf.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_tf.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_tf.id
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_linux_virtual_machine" "vm_tf" {
  name                = "Vmachine-tf"
  resource_group_name = azurerm_resource_group.testing_tf.name
  location            = azurerm_resource_group.testing_tf.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  custom_data         = filebase64("./templates/customData.tpl")
  network_interface_ids = [
    azurerm_network_interface.nic_tf.id,
  ]


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  #fill in the arguments for the linux-ssh-script.tpl
  provisioner "local-exec" {
    command = templatefile("./templates/linux-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "/home/bilel-bayoudhi/.ssh/id_rsa"
    })
    interpreter = var.host_os == "linux" ? ["bash", "-c"] : ["powershell", "-command"]
  }

  tags = {
    environment = var.environment
  }
}

data "azurerm_public_ip" "tf_ip_data" {
  name                = azurerm_public_ip.public_ip_tf.name
  resource_group_name = azurerm_resource_group.testing_tf.name
}


