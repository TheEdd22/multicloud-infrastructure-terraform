output "instance_public_ip" {
  description = "IP público da instância Compute Engine"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "instance_id" {
  description = "ID da instância Compute Engine"
  value       = google_compute_instance.main.instance_id
}

output "vpc_network_name" {
  description = "Nome da VPC criada"
  value       = google_compute_network.main.name
}

output "storage_bucket_name" {
  description = "Nome do bucket Cloud Storage criado"
  value       = google_storage_bucket.main.name
}

output "storage_bucket_url" {
  description = "URL do bucket Cloud Storage criado"
  value       = google_storage_bucket.main.url
}
