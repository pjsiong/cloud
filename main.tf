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
  subscription_id = "5387925a-1073-4218-badd-44b79b144511"
  client_id       = "23273d00-8589-4600-af59-2040ae7a9caa"
  client_secret   = "7pf5wgcdZG.Nm~luEK.ReyM.~47XHmdm-8"
  tenant_id       = "545b5243-ef8b-49a7-ad4e-77d48c0f2abb"

  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = "AZU-R-Sandbox_Terraform-remote"
  location = "eastasia"

  tags = {
    description = "Resource group created in sandbox with remote backend"
    Team        = "Testing"
  }
}
