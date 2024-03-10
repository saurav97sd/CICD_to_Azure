// First we will create a Resource Group
resource "azurerm_resource_group" "tf_rg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

// Resource block to create Virtual Network
resource "azurerm_virtual_network" "tf_vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name
}

// Resource block to create subnet inside the previously created VNet
resource "azurerm_subnet" "tf_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tf_rg.name
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

// Resource block to create the network interface for our VM
resource "azurerm_network_interface" "tf_nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

// Resource block to create the Virtual Machine
resource "azurerm_linux_virtual_machine" "tf_linux_vm" {
  name                = "${var.prefix}-virtual-machine"
  resource_group_name = azurerm_resource_group.tf_rg.name
  location            = azurerm_resource_group.tf_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.tf_nic.id,
  ]

  # It is recommended to use ssh-keys instead of password but since we are just testing we are using password
  admin_password                  = var.password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}