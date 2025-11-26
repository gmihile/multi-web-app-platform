resource "aws_sns_topic" "sns_alert" {
    name = "cpu_instance_metric_alert"

    tags = {
        Name = "Cloud Watch Alarm topic"
    }

}

resource "aws_sns_topic_subscription" "subscription" {
    topic_arn = aws_sns_topic.sns_alert.arn
    protocol = "email"
    endpoint = "xxxxxxxxxxxxx"


}


