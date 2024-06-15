output "noncba" {
  value = {

      host     = google_sql_database_instance.noncba.ip_address.0.ip_address
      port     = "5432"
      user     = random_string.noncba_root_username.result
      password = random_string.noncba_root_password.result
  }
  sensitive = true
}

output "cba" {
  value = {
      host     = google_sql_database_instance.cba.ip_address.0.ip_address
      port     = "5432"
      user     = random_string.cba_root_username.result
      password = random_string.cba_root_password.result

  }
  sensitive = true
}
