## Security Group for ALB
resource "aws_security_group" "alb_security_group" {
  name        = "alb_sg"
  description = "Allow traffic from port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB security Group"
  }
}


## Security Group for ECS

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_sg"
  description = "Allow http/https traffic from port 80/443 to cointainers via the ALB Sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow http traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "Allow https traffic"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS Security group"
  }
}
