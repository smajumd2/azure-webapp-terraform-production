terraform {
    backend "azurerm" {
        resource_group_name = "Nebula"
        storage_account_name = "cinuatwhereismyworld"
        container_name = "content"
        key = "webapp.tfstate"
    }

}
