resource "aws_vpc" "web_app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web_app_vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "public_subnet_b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.web_app_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.web_app_vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app_vpc.id
}

resource "aws_internet_gateway_attachment" "igw_attachment" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.web_app_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.web_app_vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}
