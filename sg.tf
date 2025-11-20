
# Security group for alb
resource "aws_security_group" "alb_sg" {
    name = "alb_security_group"
    description = "Security group that will be attached to my ALB"
    vpc_id = aws_vpc.vpc.id

}


# Security group for ec2
resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg_group"
    description = "Security group for backend ec2 instances"
    vpc_id = aws_vpc.vpc.id
}

# security rule to allow my ALB to recieve HTTP traffic from internet

resource "aws_security_group_rule" "internet_to_alb_80" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.alb_sg.id
}

# security rule to allow my ALB to recieve HTTPS traffic from internet
resource "aws_security_group_rule" "internet_to_alb_443" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.alb_sg.id
}


# Allow my ALB to send HTTP traffic from my ALB to my ec2 instances
resource "aws_security_group_rule" "alb_to_ec2" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"

    source_security_group_id = aws_security_group.alb_sg.id
    security_group_id = aws_security_group.ec2_sg.id
}


# Allow my ALB to send HTTPS traffic from my ALB to my ec2 instances
resource "aws_security_group_rule" "alb_to_ec2_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    source_security_group_id = aws_security_group.alb_sg.id
    security_group_id = aws_security_group.ec2_sg.id
}

#Allow ec2 to send outbound traffic anywhere
resource "aws_security_group_rule" "ec2_to_any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.ec2_sg.id


}


resource "aws_security_group" "rds_db_sg" {
    name = "rds_db_sg"
    description = "Allow  MYSQL traffic from my ec2 instance application only"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 3306
        to_port =  3306
        protocol = "tcp"
        security_groups = [aws_security_group.ec2_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


}
