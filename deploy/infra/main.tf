resource "random_string" "todo-db-password" {
  length  = 32
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_instance" "todo-db-postgres" {
  identifier_prefix = "rds-psql-${var.base_name}"
  instance_class    = var.postgres_instance_class

  allocated_storage = var.postgres_storage_gb
  storage_type      = var.postgres_storage_type

  engine         = "postgres"
  engine_version = var.postgres_version

  db_name  = var.postgres_db_name
  username = var.postgres_admin_username
  password = random_string.todo-db-password.result

  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.allow-postgres-access.id]

  skip_final_snapshot = true

  tags = var.tags
}
