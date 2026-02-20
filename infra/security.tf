resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description = "Allow HTTP inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow HTTP inbound traffic from ALB and all outbound traffic"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description     = "Allow HTTP inbound traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Allow SSH inbound traffic from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic for patches and updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_security_group" "mysql_sg" {
  name   = "mysql_sg"
  vpc_id = aws_vpc.web_app_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name = "mysql_sg"
  }
}

resource "aws_security_group" "redis_sg" {
  name   = "redis_sg"
  vpc_id = aws_vpc.web_app_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name = "redis_sg"
  }
}
