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
