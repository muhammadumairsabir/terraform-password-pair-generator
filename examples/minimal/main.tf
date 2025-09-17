# Defaults generate one active + one backup, no swapping, no rotation.
module "password_pair" {
  source = "../../modules/password_pair"
}

output "active" {
  value     = module.password_pair.active_password
  sensitive = true
}

output "backup" {
  value     = module.password_pair.backup_password
  sensitive = true
}
