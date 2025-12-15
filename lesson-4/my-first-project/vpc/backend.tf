terraform {
  backend "s3" {
    bucket  = "mlops-tfstate-alex"   # той самий S3 бакет
    key     = "vpc/terraform.tfstate" # окремий шлях для VPC
    region  = "us-east-1"
    profile = "default"
    encrypt = true
  }
}