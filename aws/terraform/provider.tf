provider "aws" {
  region  = "us-east-1"
  profile = "homework"

  default_tags {
    tags = {
      Environment         = "homework"
      OwnerAutomatization = "terraform"
    }
  }
}

terraform {

  backend "s3" {
    bucket = "terraform-core-homework"
    key    = "homework-folder/homework.tfstate"
    region = "us-east-1"

    profile = "homework"
  }
}