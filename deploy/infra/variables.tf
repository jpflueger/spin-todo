###
# Required variables
###
variable "base_name" {
  type        = string
  description = "Base name to be used in all resource naming definitions"
}

###
# Optional variables
###
variable "postgres_version" {
  type        = string
  description = "The version of Postgres engine to deploy"
  default     = "13.8"
}

variable "postgres_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "postgres_storage_gb" {
  type    = number
  default = 5
}

variable "postgres_storage_type" {
  type    = string
  default = "standard"
}

variable "postgres_admin_username" {
  type    = string
  default = "postgres"
}

variable "postgres_db_name" {
  type    = string
  default = "todo"
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "postgres_ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {
  type    = map(string)
  default = {}
}