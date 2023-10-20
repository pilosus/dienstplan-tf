terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_access_token
}

resource "digitalocean_database_db" "app" {
  cluster_id = digitalocean_database_cluster.pg.id
  name       = var.database.db_name
}

# User role cannot be overriden and equals to `normal` by default,
# hence doesn't have DDL permissions!
# For DDL ops use default admin user created by the
# digitalocean_database_cluster resource
resource "digitalocean_database_user" "app" {
  cluster_id = digitalocean_database_cluster.pg.id
  name       = var.database.user_name
}


resource "digitalocean_database_cluster" "pg" {
  region     = var.do.region
  name       = var.database.cluster_name
  engine     = var.database.cluster_engine
  version    = var.database.cluster_version
  size       = var.database.cluster_size
  node_count = var.database.cluster_nodes
}

resource "digitalocean_app" "app" {
  spec {
    name   = "${var.app.name}-server"
    region = var.do.region

    alert {
      rule     = "DEPLOYMENT_FAILED"
      disabled = false
    }

    # env: DB
    env {
      key   = "DB__SERVER_NAME"
      value = digitalocean_database_cluster.pg.host
    }

    env {
      key   = "DB__PORT_NUMBER"
      value = digitalocean_database_cluster.pg.port
    }

    env {
      key   = "DB__DATABASE_NAME"
      value = digitalocean_database_db.app.name
    }

    env {
      key   = "DB__USERNAME"
      value = digitalocean_database_user.app.name
    }

    env {
      key   = "DB__PASSWORD"
      value = digitalocean_database_user.app.password
      type  = "SECRET"
    }

    # env: slack
    env {
      key   = "SLACK__TOKEN"
      value = var.slack.token
      type  = "SECRET"
    }

    env {
      key   = "SLACK__SIGN"
      value = var.slack.sign
      type  = "SECRET"
    }

    # env: alerting
    env {
      key   = "ALERTS__SENTRY_DSN"
      value = var.sentry_dsn
      type  = "SECRET"
    }

    # env: common
    env {
      key   = "APP__VERSION"
      value = var.app.version
    }

    env {
      key   = "APP__ENV"
      value = var.app.env
    }

    env {
      key   = "APP__DEBUG"
      value = var.app.debug
    }

    env {
      key   = "SERVER__LOGLEVEL"
      value = var.logging.server_loglevel
    }

    env {
      key   = "SERVER__ROOTLEVEL"
      value = var.logging.server_rootlevel
    }

    env {
      key   = "SERVER__ACCESS_LOG"
      value = var.logging.server_access_log
    }

    service {
      name               = "${var.app.name}-server"
      instance_count     = var.app.instance_count
      instance_size_slug = var.app.instance_size
      http_port          = var.app.server_port

      image {
        registry_type = var.docker.registry_type
        registry      = var.docker.registry
        repository    = var.app.name
        tag           = var.app.version
      }

      health_check {
        http_path             = var.app.healthcheck_path
        initial_delay_seconds = var.app.healthcheck_initial_delay_seconds
        period_seconds        = var.app.healthcheck_period_seconds
      }
    }

    job {
      name               = "${var.app.name}-migrate"
      kind               = "PRE_DEPLOY"
      instance_count     = var.app.instance_count
      instance_size_slug = var.app.instance_size
      run_command        = "java -jar app.jar --mode migrate"

      image {
        registry_type = var.docker.registry_type
        registry      = var.docker.registry
        repository    = var.app.name
        tag           = var.app.version
      }

      # Override DB user/password for a user with DDL permissions
      env {
        key   = "DB__USERNAME"
        value = digitalocean_database_cluster.pg.user
      }

      env {
        key   = "DB__PASSWORD"
        value = digitalocean_database_cluster.pg.password
        type  = "SECRET"
      }
    }
  }
}

resource "digitalocean_database_firewall" "app" {
  cluster_id = digitalocean_database_cluster.pg.id

  rule {
    type  = "app"
    value = digitalocean_app.app.id
  }
}
