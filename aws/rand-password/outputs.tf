output "password_store" {
  value = var.password_store
}

output "password_path" {
  value = local.password_path
}

output "password" {
  sensitive = true
  value     = concat(random_password.password.*.result, [""])[0]
}
