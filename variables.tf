variable "agent_count" {
  default = 1
}

variable "cluster_name" {
  type    = list(string)
  default = ["cluster1", "cluster2"]
}

variable "dns_prefix" {
  type    = list(string)
  default = ["cluster1", "cluster2"]
}

variable "resource_group_location" {
  type    = string
  default = "southeastasia"
}

variable "azurerm_resource_group" {
  type    = list(string)
  default = ["cluster1", "cluster2"]
}

# The following two variable declarations are placeholder references.
# Set the values for these variable in terraform.tfvars
variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}