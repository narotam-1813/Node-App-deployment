resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      "Name" = var.vpc_name
    }
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    cidr_block = element(var.public_subnets_cidr, count.index)
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]
    tags = {
      "Name" = "Public-subnet-${count.index + 1}" 
    }
}

resource "aws_internet_gateway" "vpc_ig" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "${var.vpc_name}-vpc-ig"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.vpc_ig.id
    }
    tags = {
      "Name" = "public-subnet-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    count = length(var.public_subnets_cidr)
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}