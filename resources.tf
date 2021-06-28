resource "azurerm_log_analytics_workspace" "law01" {
  name     				= "law-${var.org}-${var.region_id}-${var.env}-01"
  location            	= azurerm_resource_group.sharedsvcs.location
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  sku                 	= "PerGB2018"
  retention_in_days   	= 30
}

resource "azurerm_automation_account" "aut01" {
  name     				= "aut-${var.org}-${var.region_id}-${var.env}-01"
  location            	= azurerm_resource_group.sharedsvcs.location
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  sku_name = "Basic"
}

resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  workspace_id        	= azurerm_log_analytics_workspace.law01.id
  read_access_id      = azurerm_automation_account.aut01.id
}

resource "azurerm_log_analytics_solution" "updates" {
  solution_name         = "Updates"
  location            	= azurerm_resource_group.sharedsvcs.location
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  workspace_resource_id = azurerm_log_analytics_workspace.law01.id
  workspace_name        = azurerm_log_analytics_workspace.law01.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

resource "azurerm_log_analytics_solution" "ChangeTracking" {
  solution_name         = "ChangeTracking"
  location            	= azurerm_resource_group.sharedsvcs.location
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  workspace_resource_id = azurerm_log_analytics_workspace.law01.id
  workspace_name        = azurerm_log_analytics_workspace.law01.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}

resource "azurerm_log_analytics_solution" "SecurityCenterFree" {
  solution_name         = "SecurityCenterFree"
  location            	= azurerm_resource_group.sharedsvcs.location
  resource_group_name 	= azurerm_resource_group.sharedsvcs.name
  workspace_resource_id = azurerm_log_analytics_workspace.law01.id
  workspace_name        = azurerm_log_analytics_workspace.law01.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }
}

resource "azurerm_key_vault" "kv01" {
  name     						= "kv-${var.org}-${var.region_id}-${var.env}-01"
  location            			= azurerm_resource_group.sharedsvcs.location
  resource_group_name 			= azurerm_resource_group.sharedsvcs.name
  enabled_for_disk_encryption 	= true
  tenant_id                   	= data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  	= 7
  purge_protection_enabled    	= false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_storage_account" "sa01" {
  name     					= "sa${var.org}${var.region_id}${var.env}diag01"
  location            		= azurerm_resource_group.sharedsvcs.location
  resource_group_name 		= azurerm_resource_group.sharedsvcs.name
  account_tier             	= "Standard"
  account_replication_type 	= "LRS"
}

resource "azurerm_recovery_services_vault" "rsv01" {
  name     					= "rsv-${var.org}-${var.region_id}-${var.env}-01"
  location            		= azurerm_resource_group.sharedsvcs.location
  resource_group_name 		= azurerm_resource_group.sharedsvcs.name
  sku                 		= "Standard"
  soft_delete_enabled 		= true
}