resource "aws_security_group" "allow_public_access" {
  count = length(var.public_access_whitelisted_ips)
  name  = "${var.rds_name}-allow-public-access"

  vpc_id = var.rds_vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.public_access_whitelisted_ips
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "random_password" "master_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "master_password" {
  name        = "/${var.rds_name}/PG_PASSWORD"
  type        = "SecureString"
  value       = random_password.master_password.result

  tags = var.tags
}

module "rds" {
  source                 = "terraform-aws-modules/rds/aws"
  version                = "2.20.0"
  identifier             = var.rds_name
  engine                 = "postgres"
  engine_version         = "12.3"
  major_engine_version   = "12"
  family                 = "postgres12"
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  name                   = var.rds_db_name
  username               = var.rds_username
  password               = random_password.master_password.result
  port                   = "5432"
  backup_window          = "03:00-06:00"
  maintenance_window     = "Mon:00:00-Mon:03:00"
  subnet_ids             = var.rds_vpc_database_subnets
  vpc_security_group_ids = (length(var.public_access_whitelisted_ips) == 1 ? concat(var.rds_vpc_security_group_ids, [aws_security_group.allow_public_access.0.id]) : var.rds_vpc_security_group_ids)
  publicly_accessible    = true
  deletion_protection    = false
  storage_encrypted      = var.rds_storage_encrypted
  create_monitoring_role = false

  tags = var.tags
}

# Uncomment the module block below if you need a DB replica

# module "rds_replica" {
#   source              = "terraform-aws-modules/rds/aws"
#   version             = "2.5.0"
#   identifier          = "${var.rds_name}-replica"
#   replicate_source_db = "${module.rds.rds_this_db_instance_id}"
#   engine              = "postgres"
#   engine_version      = "11.2"
#   family              = "postgres11"
#   instance_class      = var.rds_instance_class
#   allocated_storage   = var.rds_allocated_storage

#   # Username and password should not be set for replicas
#   username               = ""
#   password               = ""
#   port                   = "5432"
#   backup_window          = "03:00-06:00"
#   maintenance_window     = "Mon:00:00-Mon:03:00"
#   vpc_security_group_ids = (length(var.public_access_whitelisted_ips) == 1 ? concat(var.rds_vpc_security_group_ids, [aws_security_group.allow_public_access.0.id]) : var.rds_vpc_security_group_ids)
#   publicly_accessible    = true
#   storage_encrypted      = var.rds_storage_encrypted

#   # Disable backup
#   backup_retention_period = 0

#   # Not allowed to specify a subnet group for replicas in the same region
#   create_db_subnet_group    = false
#   create_db_option_group    = false
#   create_db_parameter_group = false
# }