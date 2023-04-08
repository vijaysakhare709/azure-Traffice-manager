resource "azurerm_traffic_manager_profile" "apptrafice" {
  name                   = "vijaytrafice"
  resource_group_name    = azurerm_resource_group.vijayss.name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = "vijaytrafice"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
depends_on = [
    azurerm_resource_group.vijayss
]

}


resource "azurerm_traffic_manager_azure_endpoint" "primaryendpoint" {
  name               = "primdary-endpoint"
  profile_id         = azurerm_traffic_manager_profile.apptrafice.id
  priority           = 1
  weight             = 100
  target_resource_id = azurerm_linux_web_app.primaryapp.id

  custom_header {
    name  = "host"
    value = "${azurerm_linux_web_app.primaryapp.name}.azurewebsites.net"
  }

  depends_on = [
    azurerm_linux_web_app.primaryapp 
  ]

}


resource "azurerm_traffic_manager_azure_endpoint" "secondyendpoint" {
  name               = "secondy-endpoint"
  profile_id         = azurerm_traffic_manager_profile.apptrafice.id
  priority           = 2
  weight             = 100
  target_resource_id = azurerm_linux_web_app.secondyapp.id

    custom_header {
    name  = "host"
    value = "${azurerm_linux_web_app.secondyapp.name}.azurewebsites.net"
  }  

  depends_on = [
    azurerm_linux_web_app.secondyapp 
  ]

}

#y binding k liye hai ager bind karna hai web app service ke liye to  

resource "azurerm_app_service_custom_hostname_binding" "prmaydom" {
  hostname            = "${azurerm_traffic_manager_profile.apptrafice.fqdn}"
  app_service_name    = azurerm_linux_web_app.primaryapp.name
  resource_group_name = azurerm_resource_group.vijayss.name

  depends_on = [
    azurerm_traffic_manager_azure_endpoint.primaryendpoint
  ]
}
