variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region for AWS provider (має відповідати регіону EKS)"
  type        = string
  default     = "us-east-1"
}

variable "eks_state_bucket" {
  description = "S3 bucket з remote state EKS"
  type        = string
  default     = "mlops-tfstate-hw"
}

variable "eks_state_key" {
  description = "S3 key для remote state EKS"
  type        = string
  default     = "hw/terraform.tfstate"
}

variable "eks_state_region" {
  description = "Регіон бакета з remote state EKS"
  type        = string
  default     = "us-east-1"
}

variable "argocd_namespace" {
  description = "Namespace для Argo CD"
  type        = string
  default     = "infra-tools"
}

variable "argocd_chart_version" {
  description = "Версія Helm-чарту Argo CD"
  type        = string
  default     = "7.7.5" # без префіксу v — версію можна змінити
}

variable "app_repo_url" {
  description = "Публічний Git-репозиторій з маніфестами"
  type        = string
  default     = "https://github.com/alexvekh/goit-argo.git"
}

variable "app_repo_branch" {
  description = "Гілка"
  type        = string
  default     = "main"
}
