variable "location" {
  description = "Região Azure onde os recursos serão provisionados"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "cloud-reliability-rg"
}

variable "vnet_cidr" {
  description = "Bloco CIDR da Virtual Network"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloco CIDR da subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "instance_name" {
  description = "Nome base da VM e recursos associados"
  type        = string
  default     = "cloud-reliability-vm"
}

variable "vm_size" {
  description = "Tamanho (SKU) da máquina virtual"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Usuário administrador da VM"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "Chave pública SSH usada para autenticação na VM (ex.: conteúdo de ~/.ssh/id_rsa.pub)"
  type        = string
  sensitive   = true
}

variable "storage_account_tier" {
  description = "Tier da Storage Account (Standard ou Premium)"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Tipo de replicação da Storage Account"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags comuns aplicadas aos recursos"
  type        = map(string)
  default = {
    Project     = "multicloud-terraform-iac"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
