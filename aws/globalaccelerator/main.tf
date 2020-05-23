locals {
  default_tags = {
    Project     = var.project
    Region      = "n/a"
    Environment = var.environment
    Terraform   = "true"
    CostCenter  = var.cost_center
  }
}

resource "aws_globalaccelerator_endpoint_group" "endpoint_group" {
  listener_arn      = "aws_globalaccelerator_listener.listener.id"
  health_check_path = var.health_check_path
  health_check_port = var.health_check_port

  endpoint_configuration {
    endpoint_id = var.nlb_arn
    weight      = var.weight
  }
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = "aws_globalaccelerator.global_accelerator.id"
  client_affinity = var.client_affinity
  protocol        = var.protocol

  dynamic "port_range" {
    for_each = var.port_ranges
    content {
      from_port = port_range.value.from_port
      to_port   = port_range.value.to_port
    }
  }
}

resource "aws_globalaccelerator_accelerator" "global_accelerator" {
  name            = "refractr-stage"
  ip_address_type = var.ip_address_type
  enabled         = true
  tags            = merge(var.extra_tags, local.default_tags)

  attributes {
    flow_logs_enabled = var.flow_logs_enabled
  }
}
