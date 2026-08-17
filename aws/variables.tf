variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloco CIDR da subnet pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_name" {
  description = "Nome da instância EC2 (tag Name)"
  type        = string
  default     = "cloud-reliability-ec2"
}

variable "instance_type" {
  description = "Tipo/tamanho da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI utilizada para a instância EC2 (padrão: Amazon Linux 2023 em us-east-1). Ajuste para outra região."
  type        = string
  default     = "ami-0c101f26f147fa7fd"
}

variable "bucket_name" {
  description = "Nome do bucket S3 (deve ser globalmente único). Se vazio, um nome é gerado automaticamente."
  type        = string
  default     = ""
}

variable "ssh_ingress_cidr" {
  description = "CIDR permitido para acesso SSH (porta 22). Restrinja em produção."
  type        = string
  default     = "0.0.0.0/0"
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
