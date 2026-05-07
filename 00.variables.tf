
variable "project_id" {
  description = "ID de votre projet GCP"
  type        = string
  default = "poc1-489913"
}

variable "region" {
  default = "us-central1"
  type    = string
}

variable "studio_db_password" {
  description = "Password for the Cloud SQL Studio user"
  type        = string
  sensitive   = true
}