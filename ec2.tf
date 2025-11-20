# Finds and reads latest AMI through a value pattern
data "aws_ami" "instance_ami" {
    most_recent = true
    owners = ["amazon"]


    filter {
        name = "name"
        values = [var.ami_value_pattern]

    }

    filter {
        name = "state"
        values = ["available"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}

# Preps Launch template
resource "aws_launch_template" "project_template" {
    name = "aws-launch-template-instances-project"
    image_id = data.aws_ami.instance_ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    user_data =  base64encode(var.user_data_script)

    tag_specifications  {
        resource_type = "instance"
        tags = {
            Name = "web-server"
        }
    }

    }

# Auto scalling group desired deployment
resource "aws_autoscaling_group" "asg_web_app" {
    name = "web-asg"

    launch_template {
        id = aws_launch_template.project_template.id
        version = "$Latest"
    }
    min_size = var.minimum_instance_amount
    max_size = var.maximum_instance_amount
    desired_capacity = var.desired_instance_amount

    vpc_zone_identifier = [
        aws_subnet.private_subnet_1.id,
        aws_subnet.private_subnet_2.id,
        aws_subnet.private_subnet_3.id,
    ]

    health_check_type = "ELB"
    health_check_grace_period = var.health_check_grace_period
    target_group_arns = [aws_lb_target_group.alb_tg_group.arn]

    tag  {
         key = "Name"
         value = "web-server-asg"
         propagate_at_launch = true
    }
}


# Scaling policy to add instances

resource "aws_autoscaling_policy" "aws_asg_policy_up" {
    name = "web-app-scale-up-policy"
    autoscaling_group_name = aws_autoscaling_group.asg_web_app.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 1
    cooldown = 300
    policy_type = "SimpleScaling"

}

resource "aws_autoscaling_policy" "aws_asg_policy_down" {
    name = "web-app-scale-down-policy"
    autoscaling_group_name = aws_autoscaling_group.asg_web_app.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown = 300
    policy_type = "SimpleScaling"
}

# CloudWatch Alarm

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
alarm_name = "HighCPUAlarm"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
statistic = "Average"
period = 60
evaluation_periods = 2
threshold = 70
comparison_operator = "GreaterThanThreshold"
alarm_description =  "Scale if CPU utilization is greater than 70% across all instances in the specified ASG. "

dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_web_app.name
}

alarm_actions = [
    aws_autoscaling_policy.aws_asg_policy_up.arn
]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
alarm_name = "LowCPUAlarm"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
statistic = "Average"
period = 60
evaluation_periods = 2
threshold = 20
comparison_operator = "LessThanThreshold"
alarm_description = "If the average CPUUTILIZATION from instances falls under 20% scale down an instance. "

dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_web_app.name
}
alarm_actions = [aws_autoscaling_policy.aws_asg_policy_down.arn]

}
