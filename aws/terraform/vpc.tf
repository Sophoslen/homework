# Create VPC 
resource "aws_vpc" "redis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Create internet gateway 
resource "aws_internet_gateway" "redis_ig" {
  vpc_id = aws_vpc.redis_vpc.id
}

# Configure Route Table
resource "aws_route" "redis_route_table" {
  route_table_id         = aws_vpc.redis_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.redis_ig.id
}

# Create subnet
resource "aws_subnet" "redis_subnet" {
  vpc_id     = aws_vpc.redis_vpc.id
  cidr_block = "10.0.1.0/24"
}

//Create Security Group
resource "aws_security_group" "allow_redis_connection" {
  name        = "allow_redis_connection"
  description = "Allow connection for redis node"
  vpc_id      = aws_vpc.redis_vpc.id

  ingress {
    description = "Allow redis inbound traffic"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.redis_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
