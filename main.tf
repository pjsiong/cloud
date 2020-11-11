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


variable "prefix" {
  default = "AZU-R-Sandbox_"
}

variable "resource_group" {
  default = "AZU-R-Sandbox_Terraform"
}

variable "location" {
  default = "eastasia"
}


resource "azurerm_virtual_network" "main" {
  name                = "var.prefix"-network
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
  name                = var.prefix-nic
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.prefix-vm
  location            = var.location
  resource_group_name = var.resource_group
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
