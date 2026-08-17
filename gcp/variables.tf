variable "project_id" {
  description = "ID do projeto GCP onde os recursos serão provisionados"
  type        = string
}

variable "region" {
  description = "Região GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona GCP"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Nome da instância Compute Engine"
  type        = string
  default     = "cloud-reliability-vm"
}

variable "machine_type" {
  description = "Tipo de máquina da instância Compute Engine"
  type        = string
  default     = "e2-micro"
}

variable "subnet_cidr" {
  description = "Bloco CIDR da subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "bucket_name" {
  description = "Nome do bucket Cloud Storage (deve ser globalmente único). Se vazio, um nome é gerado automaticamente."
  type        = string
  default     = ""
}

variable "bucket_location" {
  description = "Localização do bucket Cloud Storage"
  type        = string
  default     = "US"
}

variable "ssh_source_ranges" {
  description = "CIDRs permitidos para acesso SSH (porta 22). Restrinja em produção."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "labels" {
  description = "Labels comuns aplicados aos recursos"
  type        = map(string)
  default = {
    project     = "multicloud-terraform-iac"
    environment = "dev"
    managed-by  = "terraform"
  }
}
