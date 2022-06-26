# Creamos la VPC donde sera implementados el ambiente
resource "aws_vpc" "new_vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = var.dnsSupport
  tags = {
    Name = "New_vpc_Obligatorio"
  }
}

# Creamos las subredes publicas y privadas asociadas a una zona de dispoinibilidad
resource "aws_subnet" "public_subnetA" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.subPublicA
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_subnet_A"
  }
}

resource "aws_subnet" "public_subnetB" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.subPublicB
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_subnet_B"
  }
}

resource "aws_subnet" "private_subnetA" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.subPrivateA
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet_A"
  }
}
resource "aws_subnet" "private_subnetB" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.subPrivateB
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet_B"
  }
}

# para poder tener salida a internet se crea un internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    Name = "igw-app"
  }
}

# creamos una route table para la vpc y le adjuntamos la igw
resource "aws_route_table" "route_igw" {
  vpc_id = aws_vpc.new_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "route_igw_app"
  }
}

resource "aws_route_table_association" "route_pub_subA" {
  subnet_id      = aws_subnet.public_subnetA.id
  route_table_id = aws_route_table.route_igw.id
}

resource "aws_route_table_association" "route_pub_subB" {
  subnet_id      = aws_subnet.public_subnetB.id
  route_table_id = aws_route_table.route_igw.id
}