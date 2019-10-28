data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "GuardDuty2Slack"
  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}"

  tags {
    Name        = "GuardDuty2Slack"
    Environment = "Prod"
    Department  = "Engineering"
    Team        = "Cloud"
    Product     = "Cloud"
    Service     = "Guard Duty"
    Owner       = "cloud@my.domain"
  }
}

resource "aws_iam_policy_attachment" "lambda" {
  name = "GuardDuty2Slack"
  roles = ["${aws_iam_role.lambda.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
