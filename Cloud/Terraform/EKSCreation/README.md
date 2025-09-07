# ============================================================================
# File: README.md (inline)
# Steps to use:
# 1) Prereqs: Terraform >= 1.5, AWS CLI v2, an AWS account with permissions for VPC/EKS/EC2/IAM.
# 2) Export credentials or run `aws configure` (profile defaults are fine).
# 3) Create files above in a folder, then:
#      terraform init
#      terraform fmt
#      terraform plan -out tfplan
#      terraform apply tfplan
# 4) Fetch kubeconfig for kubectl:
#      aws eks update-kubeconfig --region $(terraform output -raw region) \
#        --name $(terraform output -raw cluster_name)
# 5) Test:
#      kubectl get nodes -o wide
# 6) Clean up when done:
#      terraform destroy
#
# Customization tips:
# - Change region/instance types/size via variables. For spot nodes, set capacity_type to "SPOT".
# - To keep API private, set cluster_endpoint_public_access = false and ensure you have connectivity to private subnets (VPN/EC2 bastion).
# - Add more node groups under eks_managed_node_groups for workloads with different sizes or taints.
# - Add addons like aws-ebs-csi-driver:
#     cluster_addons = { aws-ebs-csi-driver = { most_recent = true } }
