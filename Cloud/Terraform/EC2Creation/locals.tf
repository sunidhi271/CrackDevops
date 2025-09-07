# Purpose: Naming & AZ convenience
# ============================================================================
locals {
name_prefix = "${var.project_name}-eks"


# Pick first N AZs in the region
azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}
