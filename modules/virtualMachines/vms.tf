resource "azurerm_linux_virtual_machine" "vm_tf" {
  name                = "Vmachine-tf"
  resource_group_name = var.resourceGroupName
  location            = var.resourceGroupLocation
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  custom_data         = filebase64("${path.root}/templates/customData.tpl")
  network_interface_ids = [
    var.nicId,
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
    command = templatefile("${path.root}/templates/linux-ssh-script.tpl", {
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

# data "azurerm_public_ip" "tf_ip_data" {
#   name                = var.publicIpId
#   resource_group_name = var.resourceGroupName
# }