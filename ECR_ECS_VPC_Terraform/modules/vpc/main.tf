## Create VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


## Create IGW and attach it to VPC

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

## Get all AZs in region using data source
data "aws_availability_zones" "available_zones" {}

##Subnets

# Create Public Subnet AZ-1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ-1"
  }
}

# Create Public Subnet AZ-2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet AZ-2"
  }
}

## Create Route Table and Map it to public route
resource "aws_route_table" "public_rt_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_rt_table_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}


##  Associate public subnet AZ-1 to public route table
resource "aws_route_table_association" "public_subnet_az1_rt_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt_table.id
}


##  Associate public subnet AZ-2 to public route table
resource "aws_route_table_association" "public_subnet_az2_rt_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt_table.id
}



# Create Private Subnet for Application in AZ-1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private App Subnet AZ-1"
  }
}

# Create Private Subnet for Application in AZ-2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private App Subnet AZ-2"
  }
}


# Create Private Subnet AZ-1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private data Subnet AZ-1"
  }
}

# Create Private Subnet AZ-2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private data Subnet AZ-2"
  }
}

