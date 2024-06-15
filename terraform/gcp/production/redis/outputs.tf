output "redis" {
  value = {
    cba = {
      host    = google_redis_instance.cba.host
      port    = google_redis_instance.cba.port
      cluster = false
    }
    noncba = {
      host    = google_redis_instance.noncba.host
      port    = google_redis_instance.noncba.port
      cluster = false
    }
  }
}
