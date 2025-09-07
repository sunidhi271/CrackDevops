# Purpose: Data sources
# ============================================================================
data "aws_caller_identity" "current" {}


data "aws_availability_zones" "available" {
state = "available"
}


# Used if you later enable the kubernetes provider
data "aws_eks_cluster" "this" {
name = module.eks.cluster_name
}


data "aws_eks_cluster_auth" "this" {
name = module.eks.cluster_name
}
