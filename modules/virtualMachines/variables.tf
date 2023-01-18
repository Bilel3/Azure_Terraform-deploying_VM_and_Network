variable "resourceGroupName" {
  type        = string
  description = "rg name"
}
variable "resourceGroupLocation" {
  type        = string
  description = "rg location"
}
variable "nicId" {
  type        = string
  description = "Network Interface Identification"
}
variable publicIpId {
  type        = string
  description = "public ip Identification"
}
variable "host_os" {
  type        = string
  default     = "linux"
  description = "description"
}
variable "environment" {
  type        = string
  description = "environment"
}