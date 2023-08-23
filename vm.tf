resource "azurerm_orchestrated_virtual_machine_scale_set" "virtual_machine" {
  name                = var.virtual_machine_scale_set_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  platform_fault_domain_count = 1
  sku_name                    = "Standard_D2s_v4"
  zones                  = ["1"]
  instances = 2

  os_profile {
    linux_configuration {
      computer_name_prefix = "vmss"
      admin_username       = var.admin_username
      admin_password       = var.admin_password
      disable_password_authentication = false
    }
  }
  
  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }


  network_interface {
    name = "vm-nic-${var.environment}"
    primary = true
    enable_accelerated_networking = false

    ip_configuration {
      name      = "vm-subnet-${var.environment}"
      primary   = true
      subnet_id = azurerm_subnet.subnet.id
      public_ip_address {
        name = "public_ip"
      }
      #load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.ip_pool.id]
    }
  }
}
