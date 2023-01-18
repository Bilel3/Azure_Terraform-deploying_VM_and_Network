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
    environment = "dev"
  }
}

module "network" {
  source                = "./modules/network/networking"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
}
module "networkCon" {
  source                = "./modules/network/networkConnectivity"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  subnetName            = module.network.subnetName
  subnetId              = module.network.subnetId
}
module "networkSec" {
  source                = "./modules/network/networkSecurity"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  subnetId              = module.network.subnetId

}
module "servers" {
  source                = "./modules/virtualMachines"
  resourceGroupName     = var.resourceGroupName
  resourceGroupLocation = var.resourceGroupLocation
  nicId                 = module.networkCon.nicId
  publicIpId            = module.networkCon.publicIpId
}




