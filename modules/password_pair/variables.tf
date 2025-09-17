variable "length" {
  description = "Password length."
  type        = number
  default     = 24
}

variable "special" {
  description = "Include special characters."
  type        = bool
  default     = true
}

variable "override_special" {
  description = "Set of special characters to use (if special=true)."
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?/"
}

variable "upper" {
  description = "Include uppercase letters."
  type        = bool
  default     = true
}

variable "lower" {
  description = "Include lowercase letters."
  type        = bool
  default     = true
}

variable "numeric" {
  description = "Include numeric characters."
  type        = bool
  default     = true
}

variable "min_upper" {
  description = "Minimum number of uppercase letters."
  type        = number
  default     = 1
}

variable "min_lower" {
  description = "Minimum number of lowercase letters."
  type        = number
  default     = 1
}

variable "min_numeric" {
  description = "Minimum number of numeric characters."
  type        = number
  default     = 1
}

variable "min_special" {
  description = "Minimum number of special characters (if special=true)."
  type        = number
  default     = 1
}

variable "swap" {
  description = "If true, the BACKUP value is exposed as 'active' and the ACTIVE value is exposed as 'backup'. This does NOT regenerate passwords."
  type        = bool
  default     = false
}

variable "active_init_nonce" {
  description = "Keeper for the active password. Change ONLY if you need to rotate the ACTIVE password (not normally required)."
  type        = string
  default     = "initial"
}

variable "backup_rotation_nonce" {
  description = "Change this value whenever you want to rotate ONLY the BACKUP password. Keep it stable otherwise."
  type        = string
  default     = "v1"
}
