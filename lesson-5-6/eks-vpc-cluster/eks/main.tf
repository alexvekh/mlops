module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>21.0"

  name    = "my-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                 = {}
    eks-pod-identity-agent  = {
      before_compute = true
    }
    kube-proxy              = {}
    vpc-cni                 = {
      before_compute = true
    }
  }

  enable_cluster_creator_admin_permissions = true
  endpoint_public_access = true

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  eks_managed_node_groups = {
    node_group_1 = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    node_group_2 = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
  tags = {
    Enviroment = "goit"
  }
}
