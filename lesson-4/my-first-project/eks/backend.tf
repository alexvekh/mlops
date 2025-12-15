terraform {
  backend "s3" {
    bucket         = "mlops-tfstate-alex"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    profile        = "default" ## ваша  назва профілю
  }
}