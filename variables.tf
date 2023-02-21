variable "host_os" {
  type        = string
  default     = "linux"
  description = "description"
}
variable "resourceGroupName" {
  type        = string
  default     = "testing_terraform"
  description = "name"
}
variable "resourceGroupLocation" {
  type        = string
  default     = "West Europe"
  description = "location"
}
variable "subnetName" {
  type        = string
  default     = "subnet-tf-test"
  description = "name of the subnet"
}
variable "environment" {
  type        = string
  default     = "dev"
  description = "envirement "
}



