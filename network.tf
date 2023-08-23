resource "azurerm_resource_group" "resource_group" {
  name     = "virtual-machine-resource-${var.environment}"
  location = var.region
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "vm-subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "network_interface" {
  name                = "vm-nic-${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "vm-nic-${var.environment}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# resource "azurerm_network_security_group" "security_grpup" {
#   name                = "vm-security-group"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   security_rule {
#     name                       = "allow-http"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "allow-https"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "allow-ssh"
#     priority                   = 102
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "attach_security_grpup" {
#   subnet_id                 = azurerm_subnet.subnet.id
#   network_security_group_id = azurerm_network_security_group.security_grpup.id
# }


# resource "azurerm_public_ip" "public_ip" {
#   name                = "lb-public-ip"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = ["1"]
#   domain_name_label   = "${azurerm_resource_group.resource_group.name}"
# }

# resource "azurerm_lb" "load_balancer" {
#   name                = "myLB"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
#   sku                 = "Standard"
#   frontend_ip_configuration {
#     name                 = "myPublicIP"
#     public_ip_address_id = azurerm_public_ip.public_ip.id
#   }
# }

# resource "azurerm_lb_backend_address_pool" "ip_pool" {
#   resource_group_name = azurerm_resource_group.resource_group.name
#   name            = "backend-address-pool"
#   loadbalancer_id = azurerm_lb.load_balancer.id
# }

# resource "azurerm_lb_rule" "lb_rule" {
#   name                           = "http"
#   loadbalancer_id                = azurerm_lb.load_balancer.id
#   resource_group_name = azurerm_resource_group.resource_group.name
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = "myPublicIP"
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ip_pool.id]
#   probe_id                       = azurerm_lb_probe.lb_probe.id
# }


# resource "azurerm_lb_probe" "lb_probe" {
#   name            = "http-probe"
#   resource_group_name            = azurerm_resource_group.resource_group.name
#   loadbalancer_id = azurerm_lb.load_balancer.id
#   protocol        = "Http"
#   port            = 80
#   request_path    = "/"
# }


# resource "azurerm_lb_nat_rule" "ssh" {
#   name                           = "ssh"
#   resource_group_name            = azurerm_resource_group.resource_group.name
#   loadbalancer_id                = azurerm_lb.load_balancer.id
#   protocol                       = "Tcp"
#   frontend_port            = 50000
#   backend_port                   = 22
#   frontend_ip_configuration_name = "myPublicIP"
# }

# resource "azurerm_public_ip" "nat_gateway_ip" {
#   name                = "nat-gateway-ip"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   zones               = ["1"]
# }

# resource "azurerm_nat_gateway" "nat_gateway" {
#   name                    = "nat-gateway-new"
#   location                = azurerm_resource_group.resource_group.location
#   resource_group_name     = azurerm_resource_group.resource_group.name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
#   zones                   = ["1"]
# }

# resource "azurerm_subnet_nat_gateway_association" "example" {
#   subnet_id      = azurerm_subnet.subnet.id
#   nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
# }

# resource "azurerm_nat_gateway_public_ip_association" "example" {
#   public_ip_address_id = azurerm_public_ip.nat_gateway_ip.id
#   nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
# }