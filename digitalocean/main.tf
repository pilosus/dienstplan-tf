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

# DB pwd: digitalocean_database_user.app.password

# TODO dropplet / app

# resource "digitalocean_app" "app" {}

# TODO firewall DB

# resource "digitalocean_database_firewall" "app" {
#   cluster_id = digitalocean_database_cluster.pg.id

#   rule {
#     type  = "app"
#     value = digitalocean_app.app.id
#   }
# }
