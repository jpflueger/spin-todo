output "postgres_endpoint" {
  value = aws_db_instance.todo-db-postgres.endpoint
}

output "postgres_admin_password" {
  sensitive = true
  value     = aws_db_instance.todo-db-postgres.password
}