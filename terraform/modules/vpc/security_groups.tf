resource "aws_security_group" "webApp_vpc_sg" {
  name        = "webApp-sg"
  description = "allow SSH and port 5000"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "webApp-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.webApp_vpc_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "22"
  to_port           = "22"
}

resource "aws_vpc_security_group_ingress_rule" "port_5000" {
  security_group_id = aws_security_group.webApp_vpc_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "5000"
  to_port           = "5000"
}

resource "aws_vpc_security_group_egress_rule" "outbound_app" {
  security_group_id = aws_security_group.webApp_vpc_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
}

# Redis 

resource "aws_security_group" "redis_vpc_sg" {
  name        = "redis-sg"
  description = "Allow access to port 6379 only from the Flask app"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "redis-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "port_6379" {
  security_group_id            = aws_security_group.redis_vpc_sg.id
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.webApp_vpc_sg.id
  from_port                    = "6379"
  to_port                      = "6379"
}
