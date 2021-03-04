
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = data.aws_vpc.this.cidr_block
}

output "public_subnets" {
  value = data.aws_subnet_ids.public.ids
}

output "private_subnets" {
  value = data.aws_subnet_ids.private.ids
}
