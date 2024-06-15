resource "google_redis_instance" "cba" {
  name           = "${var.app_name}-redis-cba"
  tier           = "STANDARD_HA"
  memory_size_gb = 20

  authorized_network      = var.network.id
  region                  = var.region
  location_id             = var.region_zone
  alternative_location_id = var.region_zone_backup

  redis_version = "REDIS_6_X"
  display_name  = "${var.app_name}-redis-system"
}

resource "google_redis_instance" "noncba" {
  name           = "${var.app_name}-redis-noncba"
  tier           = "STANDARD_HA"
  memory_size_gb = 20

  authorized_network      = var.network.id
  region                  = var.region
  location_id             = var.region_zone
  alternative_location_id = var.region_zone_backup

  redis_version = "REDIS_6_X"
  display_name  = "${var.app_name}-redis-cache"
}
