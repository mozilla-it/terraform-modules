output "password_store" {
  value = var.password_store
}

output "password" {
  sensitive = true
  value     = concat(random_password.password.*.result, [""])[0]
}
