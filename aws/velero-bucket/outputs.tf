output "bucket_name" {
  value = aws_s3_bucket.backup_bucket.id
}

output "velero_iam_user_name" {
  value = aws_iam_user.velero_iam_user.name
}

output "velero_iam_user_access_key" {
  value = aws_iam_access_key.velero_iam_access_key.id
}

output "velero_iam_user_secret_key" {
  value = aws_iam_access_key.velero_iam_access_key.secret
}

output "velero_role_name" {
  value = module.velero_role.this_iam_role_name
}

output "velero_role_arn" {
  value = module.velero_role.this_iam_role_arn
}
