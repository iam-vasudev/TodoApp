resource "aws_vpc" "main" {
cidr_block = var.vpc_cidr
tags = { Name = "todoapp-vpc" }
}


resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.main.id
tags = { Name = "todoapp-igw" }
}


resource "aws_subnet" "public" {
count = length(var.public_subnets)
vpc_id = aws_vpc.main.id
cidr_block = var.public_subnets[count.index]
map_public_ip_on_launch = true
availability_zone = data.aws_availability_zones.available.names[count.index]
tags = { Name = "todoapp-public-${count.index + 1}" }
}


data "aws_availability_zones" "available" {
state = "available"
}


resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
tags = { Name = "todoapp-public-rt" }
}


resource "aws_route_table_association" "public_assoc" {
count = length(aws_subnet.public)
subnet_id = aws_subnet.public[count.index].id
route_table_id = aws_route_table.public.id
}