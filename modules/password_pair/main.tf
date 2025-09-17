terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

# Track last-known rotation nonce (to detect rotations)
resource "terraform_data" "rotation_state" {
  input = {
    backup_rotation_nonce = var.backup_rotation_nonce
  }
}

# Active password: created once, stable unless you explicitly bump active_init_nonce
resource "random_password" "active" {
  length           = var.length
  special          = var.special
  override_special = var.override_special
  upper            = var.upper
  lower            = var.lower
  numeric          = var.numeric
  min_upper        = var.min_upper
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  #exclude_chars    = var.exclude_chars

  keepers = {
    init = var.active_init_nonce
  }
}

# Backup password: rotates only when you bump backup_rotation_nonce
resource "random_password" "backup" {
  length           = var.length
  special          = var.special
  override_special = var.override_special
  upper            = var.upper
  lower            = var.lower
  numeric          = var.numeric
  min_upper        = var.min_upper
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  #exclude_chars    = var.exclude_chars

  keepers = {
    rotation = var.backup_rotation_nonce
  }
}

# Safety check: don’t allow “rotate + swap” in the same apply
resource "terraform_data" "guard" {
  lifecycle {
    precondition {
      condition = !(
        var.swap &&
        try(terraform_data.rotation_state.input.backup_rotation_nonce, null) != var.backup_rotation_nonce
      )
      error_message = "You can’t rotate the backup AND swap passwords in the same apply. Do them in two steps."
    }
  }
}
