output "endpoint" {
  value = aws_db_instance.default.endpoint
}

output "username" {
  value = local.username
}

output "password" {
  value = random_password.password.result
}

