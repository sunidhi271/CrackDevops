variable "project_name" { type = string default = "demo" }
variable "region" { type = string default = "ap-south-1" } # Mumbai


variable "cluster_version" {
type = string
default = "1.29"
description = "EKS Kubernetes version"
}

variable "vpc_cidr" { type = string default = "10.0.0.0/16" }

variable "az_count" {
type = number
default = 3
description = "How many AZs to span (1–3 typical)."
}

variable "node_instance_types" {
type = list(string)
default = ["t3.medium"]
}

variable "node_desired_size" { type = number default = 2 }
variable "node_min_size" { type = number default = 1 }
variable "node_max_size" { type = number default = 4 }
