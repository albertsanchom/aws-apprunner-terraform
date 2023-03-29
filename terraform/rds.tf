# ---------------------------------------------------------------------------------------------------------------------
# RDS DB SUBNET GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "petclinic-db-subnet-grp"
  description = "Database Subnet Group"
 # subnet_ids  = aws_subnet.public.*.id
 # subnet_ids  = aws_subnet.private.*.id
  subnet_ids = [data.aws_subnet.public1.id, data.aws_subnet.public2.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# RDS (MYSQL)
# ---------------------------------------------------------------------------------------------------------------------

resource "random_password" "random_password_rds" {
  length  = 20
  special = false
}

resource "aws_db_instance" "db" {
  identifier              = "petclinic"
  allocated_storage       = 5
  engine                  = "mysql"
  engine_version          = "5.7"
  port                    = "3306"
  instance_class          = var.db_instance_type
  db_name                 = var.db_name
  username                = var.db_user
  password                = random_password.random_password_rds.result
  availability_zone       = "${var.aws_region}a"
  vpc_security_group_ids  = [aws_security_group.db-sg.id]
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-grp.id
  parameter_group_name    = "default.mysql5.7"
  publicly_accessible     = true
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "${var.stack}-db"
  }
}

resource "aws_ssm_parameter" "default_postgres_ssm_parameter_identifier" {
  name  = format("/rds/db/%s/identifier", aws_db_instance.db.identifier)
  value = aws_db_instance.db.identifier
  type  = "String"

  overwrite = true
}

resource "aws_ssm_parameter" "default_postgres_ssm_parameter_endpoint" {
  name  = format("/rds/db/%s/endpoint", aws_db_instance.db.identifier)
  value = aws_db_instance.db.endpoint
  type  = "String"

  overwrite = true
}

resource "aws_ssm_parameter" "default_postgres_ssm_parameter_username" {
  name  = format("/rds/db/%s/superuser/username", aws_db_instance.db.identifier)
  value = aws_db_instance.db.username
  type  = "String"

  overwrite = true
}

resource "aws_ssm_parameter" "default_postgres_ssm_parameter_password" {
  name  = format("/rds/db/%s/superuser/password", aws_db_instance.db.identifier)
  value = aws_db_instance.db.password
  type  = "SecureString"

  overwrite = true
}