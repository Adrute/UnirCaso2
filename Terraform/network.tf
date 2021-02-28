# Creación de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
    name                = "kubernetesnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "CP2"
    }
}

# Creación de subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
    name                   = "terraformsubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.myNet.name
    address_prefixes       = ["10.0.1.0/24"]

}

# Creación de NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

# Nic para master y nfs
resource "azurerm_network_interface" "myNicMasterNfs" {
  name                = "nic-${var.vms_master_nfs[count.index]}" 
  count               = length(var.vms_master_nfs)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "myipconfiguration1"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index + 10}"
    public_ip_address_id           = azurerm_public_ip.myPublicIpMasterNfs[count.index].id
  }

    tags = {
        environment = "CP2"
    }

}

# Nic para workers
resource "azurerm_network_interface" "myNicWorkers" {
  name                = "nic-${var.vms_workers[count.index]}" 
  count               = length(var.vms_workers)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "myipconfiguration1"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index + 11}"
    public_ip_address_id           = azurerm_public_ip.myPublicIpWorkers[count.index].id
  }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

# Public IP para master y nfs
resource "azurerm_public_ip" "myPublicIpMasterNfs" {
  name                = "pubip-${var.vms_master_nfs[count.index]}"
  count               = length(var.vms_master_nfs)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}

# Public IP para workers
resource "azurerm_public_ip" "myPublicIpWorkers" {
  name                = "pubip-${var.vms_workers[count.index]}"
  count               = length(var.vms_workers)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}