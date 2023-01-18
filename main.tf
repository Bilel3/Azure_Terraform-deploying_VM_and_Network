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
  name     = var.resourceGroupName
  location = var.resourceGroupLocation
  tags = {
    environment = var.environment
  }
}

module "network" {
  source                = "./modules/network/subnetting"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  environment           = var.environment
  depends_on=["azurerm_resource_group.testing_tf"]
}
module "networkCon" {
  source                = "./modules/network/networkConnectivity"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  subnetName            = module.network.subnetName
  subnetId              = module.network.subnetId
  environment           = var.environment
  depends_on=["module.network"]
}
module "networkSec" {
  source                = "./modules/network/networkSecurity"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  subnetId              = module.network.subnetId
  environment           = var.environment
  depends_on=["module.networkCon"]

}
module "servers" {
  source                = "./modules/virtualMachines"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  nicId                 = module.networkCon.nicId
  publicIpId            = module.networkCon.publicIpId
  environment           = var.environment
  depends_on=["module.networkSec"]
}




