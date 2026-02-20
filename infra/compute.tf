data "aws_ami" "al_23" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.al_23.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_a.id
  security_groups             = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/install_wp.sh", {})

  tags = {
    Name = "web_server"
  }
}

resource "aws_lb" "web_app_lb" {
  name               = "web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  tags = {
    Name = "web_app_lb"
  }
}

resource "aws_lb_target_group" "web_app_target_group" {
  name     = "web-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web_app_vpc.id

  tags = {
    Name = "web_app_target_group"
  }
}

resource "aws_lb_target_group_attachment" "web_app_target_group_attachment" {
  target_group_arn = aws_lb_target_group.web_app_target_group.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}

resource "aws_lb_listener" "web_app_lb_listner" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }
}
