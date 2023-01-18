output "nicId" {
  value = azurerm_network_interface.nic_tf.id
}
output "publicIpId" {
  value = azurerm_public_ip.public_ip_tf.id
}