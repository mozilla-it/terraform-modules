output "bucket_name" {
  value = element(concat(aws_s3_bucket.this.*.id, tolist([""])), 0)
}

output "velero_iam_user_name" {
  value = element(concat(aws_iam_user.velero_iam_user.*.name, tolist([""])), 0)
}

output "velero_iam_user_access_key" {
  value = element(concat(aws_iam_access_key.velero_iam_access_key.*.id, tolist([""])), 0)
}

output "velero_iam_user_secret_key" {
  value = element(concat(aws_iam_access_key.velero_iam_access_key.*.secret, tolist([""])), 0)
}

output "velero_role_name" {
  value = module.velero_role.this_iam_role_name
}

output "velero_role_arn" {
  value = module.velero_role.this_iam_role_arn
}

output "velero_kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "velero_kms_key_id" {
  value = aws_kms_key.this.key_id
}

output "velero_kms_alias_arn" {
  value = aws_kms_alias.this.arn
}

output "velero_kms_alias_target_key_id" {
  value = aws_kms_alias.this.target_key_id
}

output "velero_kms_alias_target_key_arn" {
  value = aws_kms_alias.this.target_key_arn
}
