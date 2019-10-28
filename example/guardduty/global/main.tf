provider "aws" {
  region  = "us-west-1"
  profile = "master"
}

terraform {
  backend "s3" {
    bucket  = "tfstate"
    key     = "master/global/guardduty.tfstate"
    region  = "us-west-1"
    profile = "master"
  }
}
