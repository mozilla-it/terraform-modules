output "ecr_arn" {
  value = "${aws_ecr_repository.this.arn}"
}

output "ecr_name" {
  value = "${aws_ecr_repository.this.name}"
}

output "ecr_registry_id" {
  value = "${aws_ecr_repository.this.registry_id}"
}

output "ecr_repository_url" {
  value = "${aws_ecr_repository.this.repository_url}"
}

output "ecr_iam_user" {
  value = aws_iam_access_key.this[0].user
}

output "ecr_iam_access_key" {
  value = aws_iam_access_key.this[0].id

}

output "ecr_iam_secret_access_key" {
  value = aws_iam_access_key.this[0].secret
}
