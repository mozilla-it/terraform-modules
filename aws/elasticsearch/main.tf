resource "aws_elasticsearch_domain" "cluster" {
  domain_name           = var.domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type  = var.es_instance_type
    instance_count = var.es_instance_count
  }

  vpc_options {
    subnet_ids = var.subnet_ids

    security_group_ids = [aws_security_group.cluster_sg.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = var.tags
}

resource "aws_security_group" "cluster_sg" {
  name        = "${var.domain_name}-es-sg"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    security_groups = [
      var.ingress_security_groups,
    ]
  }
}

data "aws_iam_policy_document" "cluster_policy_doc" {
  statement {
    actions   = ["es:*"]
    resources = ["${aws_elasticsearch_domain.cluster.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_elasticsearch_domain_policy" "cluster_policy" {
  domain_name = aws_elasticsearch_domain.cluster.domain_name

  access_policies = data.aws_iam_policy_document.cluster_policy_doc.json
}
