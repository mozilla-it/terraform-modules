# Terraform module for deploying Elasticsearch clusters in AWS

Usage example:
```
module "elasticsearch_cluster" {
	source                  = "github.com/mozilla-it/terraform-modules//aws/elasticsearch"
	domain_name             = "my-es-cluster"
	subnet_ids              = element(module.vpc.private_subnets[0], 0)
	vpc_id                  = module.vpc.vpc_id
	ingress_security_groups = "sg-12345"
	ebs_volume_size         = 35
}
```
