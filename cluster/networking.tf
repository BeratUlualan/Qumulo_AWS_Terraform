resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block
  availability_zone = var.aws_az

  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]

  tags = var.tags
}

resource "aws_security_group" "main" {
  name        = "berat-test"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}


resource "aws_route53_zone" "main" {
  name = "test-berat.local"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = var.tags
}

resource "aws_route53_record" "floating-ips" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.cluster_name}.test-berat.local"
  type    = "A"
  ttl     = 1
  records = local.floating_ip_list
}

resource "aws_route53_record" "persistent-ips" {
  count   = var.node_count
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.cluster_name}-${count.index + 1}.test-berat.local"
  type    = "A"
  ttl     = 3600
  records = [var.persistent_ips["${count.index}"]]
}
