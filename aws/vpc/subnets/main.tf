resource "null_resource" "subnets" {
  count = (var.enabled == "false" ? 0 : length(var.azs))

  triggers = {
    public_subnets = cidrsubnet(var.vpc_cidr, var.newbits, count.index % length(var.azs))
    private_subnets = cidrsubnet(
      var.vpc_cidr,
      var.newbits,
      count.index % length(var.azs) + length(var.azs),
    )
  }
}

