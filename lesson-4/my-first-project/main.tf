module "vpc" {
  source  = "./vpc"
  aws_region = var.aws_region
}

module "eks" {
  source     = "./eks"
  aws_region = var.aws_region
  # subnet_ids = module.vpc.private_subnets
  
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

}


