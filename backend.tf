// Initializing the remote backend for terraform state file
// Here we have to hardcode the rg, storage account and container name. We can't use variables here.

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_backend_rg"
    storage_account_name = "tfbackend97"
    container_name       = "tfstate-remote"
    key                  = "prod.terraform.tfstate"
  }
}
