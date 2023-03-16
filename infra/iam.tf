# Create an IAM Role for Redshift
resource "aws_iam_role" "airbnb-redshift-role" {
  name = "${var.env-prefix}_airbnb_redshift_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.env-prefix}_airbnb_redshift_role"
    Environment = var.env-prefix
  }
}


# Create and assign an IAM Role Policy to access S3 Buckets
resource "aws_iam_role_policy" "airbnb-redshift-s3-full-access-policy" {
  name = "${var.env-prefix}_airbnb_redshift_role_s3_policy"
  role = aws_iam_role.airbnb-redshift-role.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": "s3:*",
       "Resource": "*"
      }
   ]
}
EOF
}


# Get the AmazonRedshiftAllCommandsFullAccess policy
data "aws_iam_policy" "airbnb-redshift-full-access-policy" {
  name = "AmazonRedshiftAllCommandsFullAccess"
}

# Attach the policy to the Redshift role
resource "aws_iam_role_policy_attachment" "attach-s3" {
  role       = aws_iam_role.airbnb-redshift-role.name
  policy_arn = data.aws_iam_policy.airbnb-redshift-full-access-policy.arn
}