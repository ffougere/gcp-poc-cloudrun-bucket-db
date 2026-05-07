resource "google_storage_bucket" "static_assets" {
  name                        = "${var.project_id}-static-files"
  location                    = var.region
  uniform_bucket_level_access = true
  labels                      = local.common_labels

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}