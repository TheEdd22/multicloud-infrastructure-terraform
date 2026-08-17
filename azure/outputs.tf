output "vm_public_ip" {
  description = "IP público da máquina virtual"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_id" {
  description = "ID da máquina virtual"
  value       = azurerm_linux_virtual_machine.main.id
}

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Nome da Storage Account criada"
  value       = azurerm_storage_account.main.name
}

output "storage_container_name" {
  description = "Nome do container Blob criado"
  value       = azurerm_storage_container.main.name
}
