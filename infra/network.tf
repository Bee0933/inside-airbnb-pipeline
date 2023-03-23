# vpc
resource "aws_vpc" "airbnb-vpc" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env-prefix}_airbnb_vpc"
  }
}

# subnets
resource "aws_subnet" "airbnb-public-subnet-1" {
  vpc_id            = aws_vpc.airbnb-vpc.id
  cidr_block        = var.airbnb-public-subnet-cidr-block-1
  availability_zone = "${var.avail-zone}a"

  tags = {
    Name = "${var.env-prefix}_public_subnet_1_avail_zone_a"
  }
}

resource "aws_subnet" "airbnb-public-subnet-2" {
  vpc_id            = aws_vpc.airbnb-vpc.id
  cidr_block        = var.airbnb-public-subnet-cidr-block-2
  availability_zone = "${var.avail-zone}b"

  tags = {
    Name = "${var.env-prefix}_public_subnet_1_avail_zone_b"
  }
}

resource "aws_subnet" "airbnb-public-subnet-3" {
  vpc_id            = aws_vpc.airbnb-vpc.id
  cidr_block        = var.airbnb-public-subnet-cidr-block-3
  availability_zone = "${var.avail-zone}c"

  tags = {
    Name = "${var.env-prefix}_public_subnet_3_avail_zone_c"
  }
}


# redshift subnet group
resource "aws_redshift_subnet_group" "redshift-subnet-group" {

  name = "redshift-subnet-group"

  subnet_ids = [aws_subnet.airbnb-public-subnet-1.id,
    aws_subnet.airbnb-public-subnet-2.id,
  aws_subnet.airbnb-public-subnet-3.id]

  tags = {

    environment = "${var.env-prefix}"
    Name        = "${var.env-prefix}-redshift-subnet-group"
  }

}


# route tables
resource "aws_route_table" "airbnb-rtb" {
  vpc_id = aws_vpc.airbnb-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airbnb-cluster-igw.id
  }

  tags = {
    Name = "${var.env-prefix}_airbnb_cluster_route_table"
  }
}

# Gateway
resource "aws_internet_gateway" "airbnb-cluster-igw" {
  vpc_id = aws_vpc.airbnb-vpc.id

  tags = {
    Name = "${var.env-prefix}_airbnb_cluster_gateway"
  }
}

# Associations
resource "aws_route_table_association" "airbnb-a-rtb-subnet-1" {
  subnet_id      = aws_subnet.airbnb-public-subnet-1.id
  route_table_id = aws_route_table.airbnb-rtb.id
}

resource "aws_route_table_association" "airbnb-a-rtb-subnet-2" {
  subnet_id      = aws_subnet.airbnb-public-subnet-2.id
  route_table_id = aws_route_table.airbnb-rtb.id
}

resource "aws_route_table_association" "airbnb-a-rtb-subnet-3" {
  subnet_id      = aws_subnet.airbnb-public-subnet-3.id
  route_table_id = aws_route_table.airbnb-rtb.id
}


# security group
resource "aws_security_group" "redshift-serverless-security-group" {
  depends_on = [aws_vpc.airbnb-vpc]

  name        = "${var.env-prefix}_airbnb_redshift_security_group"
  description = "airbnb redshift security group"

  vpc_id = aws_vpc.airbnb-vpc.id

  ingress {
    description = "Redshift port"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // update this to secure the connection to Redshift
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name        = "${var.env-prefix}_airbnb_redshift_security_group"
    Environment = var.env-prefix
  }
}
