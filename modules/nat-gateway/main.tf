## Allocate an EIP for natgateways

resource "aws_eip" "eip_nat_gateway_az1" {
  vpc = true


  tags = {
    Name = "EIP Nat-Gateway-AZ1"
  }
}

resource "aws_eip" "eip_nat_gateway_az2" {
  vpc = true

  tags = {
    Name = "EIP Nat-Gateway-AZ2"
  }
}



## Create NAT Gateway in Public subnet AZs and attach EIP using its id
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "AZ1 Nat Gateway"
  }

  depends_on = [var.internet_gateway]

}

resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "AZ1 Nat Gateway"
  }

  depends_on = [var.internet_gateway]

}

## Create Route Table for  the private subnets
resource "aws_route_table" "private_rt_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "AZ1 Route Table for Private AZ1 Subnets"
  }
}

##  Associate Private subnet AZ-1 to private route table az1
resource "aws_route_table_association" "private_app_subnet_association_az1" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_rt_table_az1.id
}

##  Associate Private subnet AZ-1 to private route table az1
resource "aws_route_table_association" "private_data_subnet_association_az1" {
  subnet_id      = var.private_data_subnet_az1_id
  route_table_id = aws_route_table.private_rt_table_az1.id
}




resource "aws_route_table" "private_rt_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "AZ2 Route Table for Private AZ2 Subnets"
  }
}


##  Associate Private subnet AZ-2 to private route table az2
resource "aws_route_table_association" "private_app_subnet_association_az2" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_rt_table_az2.id
}

##  Associate Private subnet AZ-2 to private route table az2
resource "aws_route_table_association" "private_data_subnet_association_az2" {
  subnet_id      = var.private_data_subnet_az2_id
  route_table_id = aws_route_table.private_rt_table_az2.id
}

