resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.org}-${var.region_id}-${var.env}-identity"
  location = var.region_name
}

resource "azurerm_resource_group" "network" {
  name     = "rg-${var.org}-${var.region_id}-${var.env}-network"
  location = var.region_name
}

resource "azurerm_resource_group" "sharedsvcs" {
  name     = "rg-${var.org}-${var.region_id}-${var.env}-sharedsvcs"
  location = var.region_name
}

resource "azurerm_resource_group" "management" {
  name     = "rg-${var.org}-${var.region_id}-${var.env}-management"
  location = var.region_name
}

resource "azurerm_resource_group" "temp2" {
  name     = "rg-${var.org}-${var.region_id}-${var.env}-temp2"
  location = var.region_name
}