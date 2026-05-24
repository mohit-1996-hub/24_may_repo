terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.70.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "77dfaa49-9684-4dc7-8cde-1723663746ef"


}