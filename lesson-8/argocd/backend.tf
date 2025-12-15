terraform {
  backend "s3" {
    bucket  = "mlops-tfstate-hw"
    key     = "argocd/terraform.tfstate"
    region  = "us-east-1"
    # profile = "default" # необов'язково в backend
  }
}
