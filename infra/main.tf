# resources

# prefect ECS agent
module "prefect_ecs_agent" {
  source = "github.com/PrefectHQ/prefect-recipes//devops/infrastructure-as-code/aws/tf-prefect2-ecs-agent"

  agent_subnets = [
    aws_subnet.airbnb-public-subnet-1.id,
    aws_subnet.airbnb-public-subnet-2.id,
    aws_subnet.airbnb-public-subnet-3.id
  ]
  name                     = "${var.env-prefix}-airbnb-etl"
  agent_extra_pip_packages = "prefect-aws pandas "
  prefect_account_id       = var.prefect-account-id
  prefect_api_key          = var.prefect-api-key
  prefect_workspace_id     = var.prefect-workspace-id
  vpc_id                   = aws_vpc.airbnb-vpc.id
}



# s3
resource "aws_s3_bucket" "airbnb-bucket" {
  bucket = "airbnb-bucket"

  tags = {
    Name        = "airbnb-bucket"
    Environment = var.env-prefix
  }
}

resource "aws_s3_bucket_acl" "ny-taxi-lake-acl" {
  bucket = aws_s3_bucket.airbnb-bucket.id
  acl    = "private"
}



# Redshift cluster 
resource "aws_redshift_cluster" "airbnb-redshift-cluster" {
  cluster_identifier        = "airbnb-redshift-cluster"
  database_name             = var.rs-database-name
  master_username           = var.rs-master-username
  master_password           = var.rs-master-pass
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift-subnet-group.id
  skip_final_snapshot       = true
  iam_roles                 = ["${aws_iam_role.airbnb-redshift-role.arn}"]
  depends_on                = [aws_vpc.airbnb-vpc, aws_security_group.redshift-serverless-security-group, aws_redshift_subnet_group.redshift-subnet-group, aws_iam_role.airbnb-redshift-role]

}
