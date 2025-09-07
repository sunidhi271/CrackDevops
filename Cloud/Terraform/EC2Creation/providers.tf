# Purpose: Configure AWS provider (and optionally Kubernetes once cluster exists)
# ============================================================================
provider "aws" {
region = var.region
}


# NOTE: The kubernetes provider is declared for completeness; you can enable it
# after 'terraform apply' when the cluster endpoint & auth are available.
# provider "kubernetes" {
# host = module.eks.cluster_endpoint
# cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
# token = data.aws_eks_cluster_auth.this.token
# }
