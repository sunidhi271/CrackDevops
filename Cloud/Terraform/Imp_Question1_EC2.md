Q) Create a EC2 instance in AWS using terraform ?
---
1. Create a IAM user for this. OR Fetch your usedid and token. Go to root user of aws tab > security credentials > Create a root Access key and fetch the secret.
2. Get AMI of an instance. Search EC2 in aws console --> select instances --> Click Launch Instance --> select Ubuntu/anything of your choice --> copy the AMI id written below.
3. Login to cluster from local: aws configure
- Give AWS Access key id and Secret. Give region, and give default o/p format as JSON.
4. Write a tf file: main.tf
```
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "test-ec2" {
  ami  = <get an image from EC2 UI>
  aws_instance = "t2.micro"
  subnet_id = "< get subnet-id from your VPC>"
  key_name = "<Go to EC2 --> keypairs --> create a keypair --> Copy the name of ket here>"
}
```
4. Initialize terraform, for it to understand what it needs to do, by reading the code: `teraform init`
- Run it within the directory where you have .tf files
- It installs the provider plugins.

5. Dry-run the configuration: terraform plan
- Gives errors related to template, credentials errors etc.

6. Apply the configurations: terraform apply

7. To delete the ec2 instance: terraform destroy
