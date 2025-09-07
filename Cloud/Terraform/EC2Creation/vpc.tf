# Purpose: Network using terraform-aws-modules/vpc
# ============================================================================
module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"


name = "${local.name_prefix}-vpc"
cidr = var.vpc_cidr


azs = local.azs
private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i)]
public_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 48)]


enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false


public_subnet_tags = {
"kubernetes.io/role/elb" = "1"
}


private_subnet_tags = {
"kubernetes.io/role/internal-elb" = "1"
}


tags = {
Project = var.project_name
Managed = "terraform"
}
}
