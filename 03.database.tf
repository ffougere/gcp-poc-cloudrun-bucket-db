resource "google_sql_database_instance" "main_db" {
  name             = "main-instance"
  database_version = "POSTGRES_14"
  region           = var.region
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier        = "db-f1-micro" # Taille minimale pour test
    user_labels = local.common_labels
    ip_configuration {
      ipv4_enabled    = false # Désactive l'IP publique
      private_network = google_compute_network.vpc_network.id
    }
  }
}

resource "google_sql_database" "database" {
  name     = "myappdb"
  instance = google_sql_database_instance.main_db.name
}

# ─── Studio-accessible instance (public IP, SSL required) ────────────────────
resource "google_sql_database_instance" "studio_db" {
  name             = "studio-instance"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier        = "db-f1-micro"
    user_labels = local.common_labels
    ip_configuration {
      ipv4_enabled            = true   # required for Cloud SQL Studio
      ssl_mode                = "ENCRYPTED_ONLY"
      authorized_networks {
        name  = "allow-cloud-sql-studio"
        value = "0.0.0.0/0"           # Cloud SQL Studio connects from Google infra
      }
    }
  }
}

resource "google_sql_database" "studio_database" {
  name     = "studiodb"
  instance = google_sql_database_instance.studio_db.name
}

resource "google_sql_user" "studio_user" {
  name     = "studio-user"
  instance = google_sql_database_instance.studio_db.name
  password = var.studio_db_password
}