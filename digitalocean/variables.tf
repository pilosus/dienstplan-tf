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

variable "app_version" {
  description = "Version of the app (Docker image)"
  type        = string
}

variable "docker" {
  description = "Docker image configuration"
  type = object({
    registry_type = string
    registry      = string
  })

  default = {
    registry_type = "DOCKER_HUB"
    registry      = "pilosus"
  }
}

variable "slack" {
  description = "Slack tokens"
  type = object({
    token = string
    sign  = string
  })
  sensitive = true
}

variable "sentry_dsn" {
  description = "Sentry DSN"
  type        = string
  default     = "https://public:private@localhost/1"
  sensitive   = true
}

variable "database" {
  description = "DigitalOcean Managed Database configuration"
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

variable "app" {
  description = "DigitalOcean App configuration"
  type = object({
    name                              = string
    env                               = string
    debug                             = bool
    instance_size                     = string
    instance_count                    = number
    server_port                       = number
    healthcheck_path                  = string
    healthcheck_initial_delay_seconds = number
    healthcheck_period_seconds        = number
  })

  default = {
    name                              = "dienstplan"
    env                               = "prod"
    debug                             = false
    instance_size                     = "basic-xxs"
    instance_count                    = 1
    server_port                       = 8080
    healthcheck_path                  = "/api/healthcheck"
    healthcheck_initial_delay_seconds = 30
    healthcheck_period_seconds        = 60
  }
}

variable "logging" {
  description = "Logging configuration"
  type = object({
    server_loglevel   = string
    server_rootlevel  = string
    server_access_log = bool
  })

  default = {
    server_loglevel   = "DEBUG"
    server_rootlevel  = "INFO"
    server_access_log = true
  }
}
