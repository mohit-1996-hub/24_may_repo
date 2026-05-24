resource "azurerm_resource_group" "rg" {
  for_each = var.manjul_var
  name     = each.value.rg_name
  location = each.value.location
}
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.manjul_var
  depends_on          = [azurerm_resource_group.rg]
  name                = each.value.vnet_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.add_spa
}
resource "azurerm_subnet" "subnet" {
  for_each             = var.manjul_var
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = each.value.subnet_name
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.add_pree
}
resource "azurerm_network_interface" "nic" {
  for_each            = var.manjul_var
  depends_on          = [azurerm_subnet.subnet]
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  ip_configuration {
    name                          = each.value.ipcon_name
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.manjul_var
  depends_on                      = [azurerm_network_interface.nic]
  name                            = each.value.vm_name
  location                        = each.value.location
  resource_group_name             = each.value.rg_name
  size                            = each.value.vm_size
  admin_username = each.value.username

  admin_password = each.value.userpass
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
  source_image_reference {
    publisher = each.value.publicer
    offer     = each.value.offr
    sku       = each.value.ssku
    version   = each.value.versions
  }
  os_disk {
    name                 = each.value.os_name
    caching              = each.value.cach
    storage_account_type = each.value.str_type
  }
}

