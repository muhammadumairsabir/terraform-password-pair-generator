output "active_password" {
  description = "The active password (swap decides which one this is)."
  value       = var.swap ? random_password.backup.result : random_password.active.result
  sensitive   = true
}

output "backup_password" {
  description = "The backup password (swap decides which one this is)."
  value       = var.swap ? random_password.active.result : random_password.backup.result
  sensitive   = true
}

# Raw versions, in case you need the actual resource values
output "raw_active_password" {
  value     = random_password.active.result
  sensitive = true
}

output "raw_backup_password" {
  value     = random_password.backup.result
  sensitive = true
}
