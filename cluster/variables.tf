variable "node_type" {
  type        = string
  description = "Qumulo Node Type [af, af-30tib, 5tib, 20tib]"
  default     = "af"
}


variable "aws_region" {
  type        = string
  description = "Select the AWS region"
  default     = "us-east-1"
}

variable "aws_az" {
  type        = string
  description = "Select the AWS Availability Zone for the selected AWS region"
  default     = "us-east-1a"
}

/*
variable "ami_id" {
  type        = string
  description = <<EOS
The AMI id for the version of Qumulo you wish to deploy.
Get AMIs from the AWS market place at https://go.aws/2UhGu4f
EOS
}
*/

variable "cluster_name" {
  type        = string
  description = "What to name the cluster"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "m5.xlarge"
}

variable "key_pair_name" {
  type        = string
  description = <<EOS
The name of the EC2 key pair that can be used to ssh to nodes as the 'admin'
user
EOS
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the cluster (minimum of 4)"
  default     = 4
}

variable "subnet_id" {
  type        = string
  description = <<EOS
VPC Subnet ID where nodes will be created. Must be in the same VPC as the
security_group_ids
EOS
}

variable "security_group_ids" {
  type        = list(string)
  description = <<EOS
Security groups to create clustered nodes in. Must be in the same VPC as the
subnet_id.
See https://bit.ly/2IYl5YE for Qumulo required ports.
EOS
}

variable "cidr_block" {
  type        = string
  description = "Cluster CIDR Block"
}

variable "persistent_ips" {
  type        = list(string)
  description = "Cluster Persistent IP Addresses"
  default     = ["10.0.0.5", "10.0.0.6", "10.0.0.7", "10.0.0.8"]
}
variable "floating_ips" {
  #type        = list(string)
  type        = string
  description = "Cluster Floating IP Addresses"
  default = "10.0.0.9-20"
}

variable "tags" {
  type        = map(string)
  description = ""
  default = {
    Owner   = "Berat Ulualan"
    Purpose = "Test"
  }
}
