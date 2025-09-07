# Purpose: EKS using terraform-aws-modules/eks
# ============================================================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name_prefix
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true
  manage_aws_auth                          = true

  cluster_addons = {
    coredns   = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni   = { most_recent = true }
  }

  eks_managed_node_groups = {
    default = {
      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND" # or "SPOT"

      # Spread nodes across AZs
      subnet_ids = module.vpc.private_subnets

      # Taints/labels example (commented)
      # taints = [{ key = "workload", value = "general", effect = "NO_SCHEDULE" }]
      # labels = { role = "general" }
    }
  }

  tags = {
    Project = var.project_name
    Managed = "terraform"
  }
}
