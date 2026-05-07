# 1. Créer le conteneur du secret
resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password"
  replication {
    automatic = true
  }
}

# 2. Ajouter la valeur du secret (le mot de passe)
resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = "mot-de-passe-super-secret-123" # Dans la vraie vie, utilisez une variable sensible
}

# 3. Autoriser Cloud Run à lire ce secret
# On récupère le compte de service par défaut de Cloud Run (ou un dédié)
resource "google_secret_manager_secret_iam_member" "cloud_run_secret_access" {
  secret_id = google_secret_manager_secret.db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

data "google_project" "project" {}
