terraform {
  backend "s3" {
    bucket         = "mlops-tfstate-hw"
    key            = "hw/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    profile        = "default" 
  }
}