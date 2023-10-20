variable "do_access_token" {
  description = "DigitalOcean Access Token"
  type        = string
  sensitive   = true
}

variable "do" {
  description = "DigitalOcean base configuration"
  type = object({
    region = string
  })

  default = {
    region = "fra1"
  }
}

variable "database" {
  description = "Database configuration"
  type = object({
    cluster_name    = string
    cluster_engine  = string
    cluster_version = string
    cluster_size    = string
    cluster_nodes   = number
    db_name         = string
    user_name       = string
  })

  default = {
    cluster_name    = "pg-cluster"
    cluster_engine  = "pg"
    cluster_version = "15"
    cluster_size    = "db-s-1vcpu-1gb"
    cluster_nodes   = 1
    db_name         = "dienstplan"
    user_name       = "dienstplan"
  }
}
