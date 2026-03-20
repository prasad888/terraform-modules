provider "aws" {
    region = var.region
  
}

resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.name
    }
}

#subnet creation
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count = length(var.public_subnet_cidrs)
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true      
    tags = {
        Name = "${var.name}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    count = length(var.private_subnet_cidrs)
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = false      
    tags = {
        Name = "${var.name}-private-subnet-${count.index + 1}"
    }
}

#igw creation
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.name}-igw"
    }
}   

resource "aws_eip" "natgw" {
    domain = "vpc"
    tags = {
        Name = "${var.name}-natgw-eip"
    }
}       

#nat pubsubnet
resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.natgw.id
    subnet_id = aws_subnet.public[0].id         
    tags = {
        Name = "${var.name}-natgw"
    }
}   

#route table for public subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }      
    tags = {
        Name = "${var.name}-public-route-table"
    }
}   

#route table for private subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id        
    route {
        cidr_block = "0.0.0.0/0"                      
        gateway_id = aws_nat_gateway.natgw.id
    }      
    tags = {
        Name = "${var.name}-private-route-table"
    }
}   

#route table association
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id       
    route_table_id = aws_route_table.public.id
}   

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id       
    route_table_id = aws_route_table.private.id
}   

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}


    