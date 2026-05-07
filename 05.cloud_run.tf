resource "google_cloud_run_v2_service" "app_service" {
  name     = "my-app-service"
  location = var.region
  labels   = local.common_labels

  template {
    containers {
      # image = "gcr.io/cloudrun/hello" # Remplacez par votre image
      image = "gcr.io/${var.project_id}/my-app:v1" # Votre image poussée sur Artifact Registry
      
      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.main_db.private_ip_address
      }
      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.static_assets.name
      }
      env {
        name  = "DB_USER"
        value = google_sql_user.db_user.name
      }
      env {
        name  = "DB_PASS"
        value = google_sql_user.db_user.password
      }
      env {
        name  = "DB_NAME"
        value = google_sql_database.database.name
      }
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
}

# Création d'un utilisateur DB sécurisé
resource "google_sql_user" "db_user" {
  name     = "app-user"
  instance = google_sql_database_instance.main_db.name
  password = "password-tres-securise" # Idéalement via Secret Manager
}

# Autoriser l'accès public (Optionnel, si pas de Load Balancer devant immédiatement)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  name     = google_cloud_run_v2_service.app_service.name
  location = google_cloud_run_v2_service.app_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
