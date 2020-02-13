output public_subnets {
  value = "${null_resource.subnets.*.triggers.public_subnets}"
}

output private_subnets {
  value = "${null_resource.subnets.*.triggers.private_subnets}"
}
