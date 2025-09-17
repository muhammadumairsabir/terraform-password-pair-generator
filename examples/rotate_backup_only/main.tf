module "password_pair" {
  source = "../../modules/password_pair"

  # Rotate backup by bumping this value
  backup_rotation_nonce = "v2"
}