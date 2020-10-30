provider "aws" {
  version = "~> 3.12.0"
  region  = "eu-west-1"
}

provider "aws" {
  version = "~> 3.12.0"
  alias   = "us_east_1"
  region  = "us-east-1"
}