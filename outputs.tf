# output "public_ip_address" {
#   description = "My public ip adress "
#   value       = "${azurerm_linux_virtual_machine.vm_tf.name}: ${data.azurerm_public_ip.tf_ip_data.ip_address}"
# }