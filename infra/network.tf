resource "aws_vpc" "web_app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web_app_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_region

  tags = {
    Name = "public_subnet"
  }
}