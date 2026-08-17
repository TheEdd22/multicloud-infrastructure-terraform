output "instance_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.main.public_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.main.id
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 criado"
  value       = aws_s3_bucket.main.arn
}
