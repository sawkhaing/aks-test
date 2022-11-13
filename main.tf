resource "azurerm_resource_group" "rg" {
  count    = 2
  location = var.resource_group_location
  name     = var.azurerm_resource_group[count.index]
}

resource "azurerm_kubernetes_cluster" "k8s" {
  count               = 2
  location            = var.resource_group_location
  name                = var.cluster_name[count.index]
  resource_group_name = azurerm_resource_group.rg[count.index].name
  dns_prefix          = var.dns_prefix[count.index]
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
