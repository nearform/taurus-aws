provider "aws" {
  version = "~> 2.27.0"
  region  = "eu-west-1"
}

provider "aws" {
  version = "~> 2.27.0"
  alias   = "us_east_1"
  region  = "us-east-1"
}