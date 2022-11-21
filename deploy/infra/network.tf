data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "vpc-${var.base_name}"

  # todo: make configurable
  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  azs                  = data.aws_availability_zones.available.names
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

resource "aws_security_group" "allow-postgres-access" {
  name        = "db-allow-${var.base_name}"
  description = "Allow port for PostgreSQL database."
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    cidr_blocks = var.postgres_ingress_cidr_blocks
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "postgres" {
  name       = "db-snet-group-${var.base_name}"
  subnet_ids = module.vpc.public_subnets
  tags       = var.tags
}
