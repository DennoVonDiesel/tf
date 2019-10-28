provider "aws" {
  region  = "${var.region}"
  profile = "master"
}

terraform {
  backend "s3" {}
}

resource "aws_guardduty_detector" "master" {
  enable = true
}

module "lambda" {
  source = "../lambda"
}
