resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.azurerm_resource_group
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location                         = var.resource_group_location
  name                             = var.cluster_name
  resource_group_name              = azurerm_resource_group.rg.name
  dns_prefix                       = var.dns_prefix
  http_application_routing_enabled = true
  tags = {
    Environment = "k8s"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}
