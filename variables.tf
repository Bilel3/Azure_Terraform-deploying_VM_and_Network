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



# ARM_CLIENT_ID       = "96511050-9532-4602-b6ba-96cb540ec5b4"
# ARM_CLIENT_SECRET   = "XRR8Q~F~T~_P8y4~9EMqZab0IhJiI5mBpVBqOaSQ"
# ARM_SUBSCRIPTION_ID = "38a8bd4d-ba09-4e21-8dc2-6bfb7f099a30"
# ARM_TENANT_ID       = "cf94a86c-d90f-4d9c-99fe-21003f6b3eed"

