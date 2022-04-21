terraform{
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rgtfstates"
    storage_account_name = "tfscomunidadecloud"
    container_name       = "tfstatecomunidadecloud"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}    
}

resource "azurerm_resource_group" "iaccomunidadecloud" {
    name = "iaccomunidadecloud"
    location = "Central US"
}

resource "azurerm_service_plan" "iaccomunidadecloudsp" {
    name = "iaccomunidadecloudsp"
    resource_group_name = azurerm_resource_group.iaccomunidadecloud.name
    location = "Central US"
    os_type = "Linux"
    sku_name = "F1"
}

resource "azurerm_linux_web_app" "iaccomunidadecloudapp" {
    resource_group_name = azurerm_resource_group.iaccomunidadecloud.name
    name = "iaccomunidadecloudapp"
    location = azurerm_service_plan.iaccomunidadecloudsp.location
    service_plan_id = azurerm_service_plan.iaccomunidadecloudsp.id

    site_config {
    always_on = false
    ftps_state = "AllAllowed"
    container_registry_use_managed_identity = false
    application_stack {
      docker_image = "acrcomunidadecloud.azurecr.io/mycontianer"
      docker_image_tag = "v0"
    }
  }
}