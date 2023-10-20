# database

output "db_host" {
  description = "DB host"
  value       = digitalocean_database_cluster.pg.host
}

output "db_private_host" {
  description = "DB private host"
  value       = digitalocean_database_cluster.pg.private_host
}

output "db_port" {
  description = "DB port"
  value       = digitalocean_database_cluster.pg.port
}

output "db_name" {
  description = "DB name"
  value       = digitalocean_database_db.app.name
}

output "db_username" {
  description = "DB username"
  value       = digitalocean_database_user.app.name
}

output "db_password" {
  description = "DB password"
  value       = digitalocean_database_user.app.password
  sensitive   = true
}

# app

output "app_live_url" {
  description = "App live url"
  value       = digitalocean_app.app.live_url
}

output "app_updated_at" {
  description = "App update timestamp"
  value       = digitalocean_app.app.updated_at
}

output "app_id" {
  description = "App ID"
  value       = digitalocean_app.app.id
}

output "app_active_deployment_id" {
  description = "App active deployment ID"
  value       = digitalocean_app.app.active_deployment_id
}
