# Réseau VPC
resource "google_compute_network" "vpc_network" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
}

# Subnet pour les ressources
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Connecteur VPC pour Cloud Run (nécessite une plage /28)
resource "google_vpc_access_connector" "connector" {
  name          = "run-vpc-connector"
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc_network.name
}

# Allocation d'IP privées pour Cloud SQL (Service Networking)
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}