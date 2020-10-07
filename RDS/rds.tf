data "aws_subnet" "selected1" {
  id = aws_subnet.rds_main[0].id
}

data "aws_subnet" "selected2" {
  id = aws_subnet.rds_main[1].id
}

data "aws_subnet" "selected3" {
  id = aws_subnet.rds_main[2].id
}

resource "aws_db_subnet_group" "rds_db_sub" {
  name        = "${var.rds_instance_identifier}-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = [data.aws_subnet.selected1.id, data.aws_subnet.selected2.id, data.aws_subnet.selected3.id]
  #subnet_ids  = ["aws_subnet.rds_main[0].id", "aws_subnet.rds_main[1].id", "aws_subnet.rds_main[2].id"]
  #subnet_ids  = ["aws_subnet.rds_main.*.id"]
}

#subnet_ids = ["${var.rds_subnet1}","${var.rds_subnet2}"]
#subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

resource "aws_db_instance" "rds_mysql" {
  identifier                = var.rds_instance_identifier
  allocated_storage         = 5
  engine                    = "mysql"
  engine_version            = "8.0.20"
  instance_class            = "db.t2.micro"
  name                      = var.database_name
  username                  = var.database_user
  password                  = var.database_password
  db_subnet_group_name      = aws_db_subnet_group.rds_db_sub.id
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}

resource "aws_db_parameter_group" "rds_mysql" {
  name        = "${var.rds_instance_identifier}-param-group"
  description = "RDS parameter group for mysql5.6"
  family      = "mysql8.0"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}