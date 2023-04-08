resource "azurerm_resource_group" "vijayss" {
  name     = "api-rg-pro"
  location = "North Europe"
}

resource "azurerm_resource_group" "vija-yss" {
  name     = "api-pro"
  location = "West Europe"
}


resource "azurerm_app_service_plan" "primaryplan" {
  name                = "pri-plan-appser-vijay-viceplan"
  resource_group_name = "api-rg-pro"
  location            = "North Europe"
  kind                = "Linux"
  reserved            =  true

  sku {
    tier = "Standard"
    size = "S1"
  }
  depends_on = [
    azurerm_resource_group.vijayss
  ]
}

resource "azurerm_linux_web_app" "primaryapp" {
  name                = "primaryapp-vijay-tt-yy-s"
  resource_group_name = azurerm_app_service_plan.primaryplan.resource_group_name
  location            = azurerm_app_service_plan.primaryplan.location
  service_plan_id     = azurerm_app_service_plan.primaryplan.id

  site_config {
  }

depends_on = [
    azurerm_app_service_plan.primaryplan
]
}


resource "azurerm_app_service_plan" "secondyplan" {
  name                = "secoundy-plan--vijayappserviceplan"
  resource_group_name = "api-pro"
  location            = "West Europe"
  kind                = "Linux"
  reserved            =  true

  sku {
    tier = "Standard"
    size = "S1"
  }
  depends_on = [
    azurerm_resource_group.vija-yss
  ]
}

resource "azurerm_linux_web_app" "secondyapp" {
  name                = "secondyapp-vijay-tt-yy-s"
  resource_group_name = azurerm_app_service_plan.secondyplan.resource_group_name
  location            = azurerm_app_service_plan.secondyplan.location
  service_plan_id     = azurerm_app_service_plan.secondyplan.id

  site_config {
  }

depends_on = [
    azurerm_app_service_plan.secondyplan
]
}
