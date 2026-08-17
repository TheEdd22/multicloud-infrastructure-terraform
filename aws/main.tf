terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Backend remoto recomendado para uso em equipe/produção.
  # Descomente e configure um bucket S3 + tabela DynamoDB para state locking.
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "multicloud/aws/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# Sufixo aleatório para garantir nomes únicos (ex.: bucket S3)
resource "random_id" "suffix" {
  byte_length = 4
}

# ---------------------------------------------------------------------------
# Rede: VPC, Subnet, Internet Gateway, Route Table
# ---------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.instance_name}-vpc" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { Name = "${var.instance_name}-igw" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone        = "${var.aws_region}a"

  tags = merge(var.tags, { Name = "${var.instance_name}-public-subnet" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, { Name = "${var.instance_name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------------------------
# Segurança: Security Group
# ---------------------------------------------------------------------------

resource "aws_security_group" "instance_sg" {
  name        = "${var.instance_name}-sg"
  description = "Permite SSH e HTTP de entrada"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.instance_name}-sg" })
}

# ---------------------------------------------------------------------------
# Computação: Instância EC2
# ---------------------------------------------------------------------------

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = merge(var.tags, { Name = var.instance_name })
}

# ---------------------------------------------------------------------------
# Storage: Bucket S3
# ---------------------------------------------------------------------------

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name != "" ? var.bucket_name : "cloud-reliability-${random_id.suffix.hex}"

  tags = merge(var.tags, { Name = "${var.instance_name}-bucket" })
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
