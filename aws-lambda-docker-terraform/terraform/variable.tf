variable "aws_region" {
description = "AWS region"
type = string
default = "us-east-1"
}
variable "aws_account_id" {
description = "341361567458"
type = string
}
# RDS credentials and DB info
variable "rds_db_name" {
default = "sampledb"
}
variable "rds_username" {
default = "adminuser"
}
variable "rds_password" {
description = "9096"
type = string
sensitive = true
}
# Add your variable declarations here

variable "create_lambda" {
  description = "1"
  type        = bool
  default     = true
}