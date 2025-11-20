resource "aws_lb" "alb" {

    name = "project-alb"
    internal = false
    load_balancer_type = "application"

    subnets = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id,
        aws_subnet.public_subnet_3.id
    ]

    security_groups = [aws_security_group.alb_sg.id]

}


resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"


    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_tg_group.arn
    }

}


resource "aws_alb_listener" "alb_https_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 443
    protocol = "HTTPS"
    certificate_arn = aws_acm_certificate.cert.arn


    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_tg_group.arn
    }

}




resource "aws_lb_target_group" "alb_tg_group" {
    name = "alb-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id

    health_check {
        enabled = true
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 5
        interval = 30
        path = "/health"
        protocol = "HTTP"
        port = "traffic-port"
    }


}
