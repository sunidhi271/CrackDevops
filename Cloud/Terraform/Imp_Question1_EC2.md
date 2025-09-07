Q) Create a EC2 instance in AWS using terraform ?
---
1. Create a IAM user for this. OR Fetch your usedid and token. Go to root user of aws tab > security credentials > Create a root Access key and fetch the secret.
2. Get AMI of an instance. Search EC2 in aws console --> select instances --> Click Launch Instance --> select Ubuntu/anything of your choice --> copy the AMI id written below.
3. Login to cluster from local: aws configure
- Give AWS Access key id and Secret. Give region, and give default o/p format as JSON.
4. Create a file for Variables: dev.tfvars
```
variable "environment" {
  description = "Environment type"
  type        = string
  default     = "development"
}
variable "production_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}
variable "development_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}
```
5. Write a tf file: main.tf
```
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.environment == "production" ? [var.production_subnet_cidr] : [var.development_subnet_cidr]
  }
}

resource "aws_instance" "test_ec2" {
  ami  = var.ami_id
  aws_instance = var.instance_type
  subnet_id = "< get subnet-id from your VPC>"
  key_name = "<Go to EC2 --> keypairs --> create a keypair --> Copy the name of ket here>"
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test_ec2.public_ip
}
```
6. Initialize terraform, for it to understand what it needs to do, by reading the code: `teraform init`
- Run it within the directory where you have .tf files
- It installs the provider plugins.

7. Dry-run the configuration: terraform plan
- Gives errors related to template, credentials errors etc.

8. Apply the configurations: terraform apply -var-file=dev.tfvars

7. To delete the ec2 instance: terraform destroy
