terraform {
  backend "remote" {
    organization = "PJP"

    workspaces {
      name = "ws1"
    }
  }
}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  #cls_terraform_testing

  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {}
}

locals {
  prefix = "AZU-R-Sandbox_"
}


#variable "prefix" {
#  default = "AZU-R-Sandbox_"
#}

variable "resource_group" {
  default = "AZU-R-Sandbox_Terraform"
}

variable "location" {
  default = "eastasia"
}

variable "tenant_id" {
  default = ""
}
variable "subscription_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}




resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${local.prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

