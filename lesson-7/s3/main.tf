provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "mlops-tfstate-hw"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}
