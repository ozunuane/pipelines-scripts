### NONCBA
resource "google_sql_database_instance" "noncba" {
  name             = "noncba-db-instance"
  project          = var.project
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    disk_autoresize = true
    tier            = var.postgres_tier

    backup_configuration {
      binary_log_enabled = false
    }

    database_flags {
      name  = "max_connections"
      value = 5000
    }

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = authorized_networks.value.value
        }
      }

      ipv4_enabled    = false
      private_network = var.network.id
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
      record_client_address   = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# # create database
# resource "google_sql_database" "naijapay" {
#   for_each = local.postgres_instances

#   name     = each.key
#   project  = var.project
#   instance = google_sql_database_instance.naijapay.name
# }


# create username and password
resource "random_string" "noncba_root_username" {

  length  = 16
  special = false
  number  = false
  lower   = true
  upper   = true
}

resource "random_string" "noncba_root_password" {

  length    = 16
  min_upper = 2
  min_lower = 2
  number    = true
  special   = false
}

resource "google_sql_user" "noncba_user" {
  name     = random_string.noncba_root_username.result
  password = random_string.noncba_root_password.result
  instance = google_sql_database_instance.noncba.name
  project  = var.project
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.naijapay.name]
}

resource "google_compute_global_address" "naijapay" {
  name          = "${var.app_name}-global-psconnect-ip"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  network       = var.network.id
  prefix_length = 16
}


### CBA

resource "google_sql_database_instance" "cba" {
  name             = "cba-db-instance"
  project          = var.project
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    disk_autoresize = true
    tier            = var.postgres_tier

    backup_configuration {
      binary_log_enabled = false
    }

    database_flags {
      name  = "max_connections"
      value = 5000
    }

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = authorized_networks.value.value
        }
      }

      ipv4_enabled    = false
      private_network = var.network.id
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
      record_client_address   = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# # create database
# resource "google_sql_database" "naijapay" {
#   for_each = local.postgres_instances

#   name     = each.key
#   project  = var.project
#   instance = google_sql_database_instance.naijapay.name
# }


# create username and password
resource "random_string" "cba_root_username" {
  length  = 16
  special = false
  number  = false
  lower   = true
  upper   = true
}

resource "random_string" "cba_root_password" {
  length    = 16
  min_upper = 2
  min_lower = 2
  number    = true
  special   = false
}

resource "google_sql_user" "cba_user" {

  name     = random_string.cba_root_username.result
  password = random_string.cba_root_password.result
  instance = google_sql_database_instance.cba.name
  project  = var.project
}

# resource "google_service_networking_connection" "private_vpc_connection" {
#   network                 = var.network.id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.naijapay.name]
# }

# resource "google_compute_global_address" "naijapay" {
#   name          = "${var.app_name}-global-psconnect-ip"
#   address_type  = "INTERNAL"
#   purpose       = "VPC_PEERING"
#   network       = var.network.id
#   prefix_length = 16
# }
