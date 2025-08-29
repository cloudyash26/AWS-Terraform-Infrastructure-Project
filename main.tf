# create VPC

resource "aws_vpc" "main" {                             
  cidr_block = var.cidr_block
}

# create aws_internet_gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# create subnets 

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub2"
  }
}

# create aws_route_table

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# create aws_route_table_associations of both subnets

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.example.id
}

# create security security_groups

resource "aws_security_group" "sg1" {
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "HTTP"
    from_port    = 80
    protocol  = "tcp"
    to_port      = 80
    cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
    description = "SSH"
    from_port    = 22
    protocol  = "tcp"
    to_port      = 22
    cidr_blocks = ["0.0.0.0/0"]
 }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MY-SG"
  }
}

# create ec2 instances

resource "aws_instance" "web1" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id = aws_subnet.subnet1.id
  user_data = base64encode(file("userdata.sh"))

  tags = {
    Name = "myserver1"
  }
}
resource "aws_instance" "web2" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id = aws_subnet.subnet2.id
  user_data = base64encode(file("userdata1.sh"))

  tags = {
    Name = "myserver2"
  }
}

# create aws_s3_bucket

resource "aws_s3_bucket" "example" {
  bucket = var.aws_s3_bucket
}

# create loadbalancer

resource "aws_lb" "test" {
  name               = "test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

# create aws_lb_target_group

resource "aws_lb_target_group" "tg" {
  name     = "example-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
    health_check {
    path = "/"
    port = "traffic-port"
  }
}

# create aws_lb_target_group_attachment

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

# create aws_lb_listener

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}