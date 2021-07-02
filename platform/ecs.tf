provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "Production-Fargate-Cluster"
}

resource "aws_alb" "ecs_cluster_alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = [aws_security_group.ecs_alb_security_group.id]
  subnets         = [split(",", join(",", data.terraform_remote_state.infrastructure.outputs.public_subnets))]
  #subnets = data.terraform_remote_state.infrastructure.outputs.public_subnets

  tags = {
    Name = "${var.ecs_cluster_name}-ALB"
  }
}

resource "aws_alb_target_group" "ecs_default_target_group" {
  name     = "${var.ecs_cluster_name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrastructure.outputs.vpc_id

  tags = {
    Name = "${var.ecs_cluster_name}-TG"
  }
}


resource "aws_route53_record" "ecs_load_balancer_record" {
  name = "*.${var.ecs_domain_name}"
  type = "A"
  zone_id = data.aws_route53_zone.ecs_domain.zone_id

  alias {
    evaluate_target_health  = false
    name                    = aws_alb.ecs_cluster_alb.dns_name
    zone_id                 = aws_alb.ecs_cluster_alb.zone_id
  }
}