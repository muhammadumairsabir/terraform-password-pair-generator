
# Terraform Module: Active + Backup Passwords

This module manages two passwords:
- The **active password** – the one currently in use.
- The **backup password** – a spare, ready to take over if needed.

It comes with some important features:
1. **Automatic setup** – the first time you run `terraform apply`, it generates both passwords.
2. **Backup rotation** – you can rotate (regenerate) the backup without touching the active one.
3. **Easy swapping** – you can promote the backup to become the active password, and demote the old active to backup.
4. **Idempotent** – Terraform won’t keep changing your passwords unless you explicitly tell it to.
5. **Safety guard** – you can’t rotate and swap in the same run (to avoid mistakes). You just do them in two separate applies.
6. **Works anywhere** – it works anywhere Terraform works, no special provider beyond `random`.


## How to Use

### 1. First apply
```hcl
module "passwords" {
  source = "../modules/password_pair"
}
```
Run:
```bash
terraform init
terraform apply
```
You now have an active password and a backup password.
Running `terraform apply` again without changes will do nothing (idempotent).

### 2. Rotate backup only
```hcl
module "passwords" {
  source = "../modules/password_pair"
  backup_rotation_nonce = "v2" # bump this value when you want a new backup
}
```
Run `terraform apply`. Only the backup changes. The active password stays the same.
For the next rotation, bump it to `"v3"`, then `"v4"`, and so on.

### 3. Swap active and backup
```hcl
module "passwords" {
  source = "../modules/password_pair"
  swap   = true
}
```
Run `terraform apply`.
Now the old backup becomes the active password, and the old active becomes the backup.
No regeneration happens – just a swap.

### 4. Rotate + Swap (two-step)
- Step 1: rotate by bumping `backup_rotation_nonce` and `terraform apply`.
- Step 2: set `swap = true` and `terraform apply` again.

⚠️ If you try to do both in one go, the module will stop you with an error.

## Security Notes
- **Sensitive outputs** – all outputs are flagged as sensitive = true. That means they won’t show up in your terminal unless you explicitly output them.
- **State file security** – the raw passwords are stored in Terraform state. Make sure your backend is secure (for example: AWS S3 with KMS/DynamoDB, or Terraform Cloud).
- **Customizable policy** – you can adjust the password rules (length, character sets, excluded characters) to match your organization’s requirements.
- **Controlled rotation** – the active password never changes on its own. It only rotates if you deliberately update active_init_nonce, so you don’t accidentally replace a production secret.