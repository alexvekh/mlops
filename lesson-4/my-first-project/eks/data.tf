data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "mlops-tfstate-alex"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    profile = "default" ## ваша назва профілю
  }
}