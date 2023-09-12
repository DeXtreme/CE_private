resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc-igw"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet.cidr
  availability_zone       = var.public_subnet.az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = {
    Name = "vpc-ngw-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_nat_gateway" "ngw" {
  allocation_id     = aws_eip.ngw.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public.id

  tags = {
    Name = "public-subnet-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet.cidr
  availability_zone = var.private_subnet.az

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    nat_gateway_id = aws_nat_gateway.ngw.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.${var.region}.s3"
  subnet_ids        = [aws_subnet.private.id]
  tags = {
    Name = "vpc-s3if"
  }
}