resource "aws_db_subnet_group" "rds-db-group" {
    name = "subnet-group-rds"
    subnet_ids = [aws_subnet.rds_private_subnet_1.id,aws_subnet.rds_private_subnet_2.id]

    tags = {
        Name = "rds-subnet-group"
    }

}



resource "aws_db_instance" "db_instance" {

    # Database Information

    identifier = "my-rds-db-instance"
    db_name = "rds_db"
    engine = "mysql"
    engine_version = "8.0"
    allocated_storage = 20
    instance_class = "db.t3.micro"
    multi_az = true
    skip_final_snapshot = true

    # Master user and password
    username = "authoriative_user"
    manage_master_user_password = true

    # DB networking configurations
    db_subnet_group_name = aws_db_subnet_group.rds-db-group.name
    vpc_security_group_ids = [aws_security_group.rds_db_sg.id]



}
