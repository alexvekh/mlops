terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region  = "us-east-1"   # твій регіон
  profile = "default"     # твій AWS профіль
}
