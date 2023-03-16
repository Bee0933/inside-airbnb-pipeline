
# env setup 
variable "avail-zone" {
  type        = string
  description = "Cloud region"
}

variable "aws-cred-profile" {
  type        = string
  description = "AWS credentials profile"
}

variable "env-prefix" {
  type        = string
  description = "Environment Prefix"
}

# vpc
variable "vpc-cidr-block" {
  type        = string
  description = "vpc CIDR block"
}


# subnets
variable "airbnb-public-subnet-cidr-block-1" {
  type        = string
  description = "public subnet 1 IPV4 CIDR Block"
}

variable "airbnb-public-subnet-cidr-block-2" {
  type        = string
  description = "public subnet 2 IPV4 CIDR Block"
}

variable "airbnb-public-subnet-cidr-block-3" {
  type        = string
  description = "public subnet 3 IPV4 CIDR Block"
}


# redshift 
variable "rs-database-name" {
  type        = string
  description = "redshift database name"
}

variable "rs-master-username" {
  type        = string
  description = "redshift master username"
}

variable "rs-master-pass" {
  type        = string
  description = "redshift master pass"
}


# prefect
variable "prefect-account-id" {
  type        = string
  description = "Prefect account ID"
}


variable "prefect-api-key" {
  type        = string
  description = "Prefect API key"
}


variable "prefect-workspace-id" {
  type        = string
  description = "Prefect workspace ID"
}
