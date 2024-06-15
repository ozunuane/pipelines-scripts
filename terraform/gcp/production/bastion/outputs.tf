output "bastion" {
  description = "Bastion connection configuration."
  value = {
    username    = random_string.bastion_admin_username.result
    private_key = tls_private_key.ssh-key.private_key_pem
    public_key  = tls_private_key.ssh-key.public_key_openssh
    host_name   = google_compute_instance.bastion.name
    public_ip   = google_compute_address.bastion.address
    private_ip  = google_compute_instance.bastion.network_interface.0.network_ip
  }
  sensitive = true
}
