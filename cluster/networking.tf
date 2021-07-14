resource "aws_vpc" "main" {
  count                = var.vpc_id == "" ? 1 : 0
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "main" {
  count             = var.subnet_id == "" || var.vpc_id == "" ? 1 : 0
  vpc_id            = var.vpc_id == "" ? aws_vpc.main[0].id : var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.aws_az

  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]

  tags = var.tags
}

resource "aws_security_group" "main" {
  count       = length(var.security_group_ids) == 0 || var.vpc_id == "" ? 1 : 0
  name        = "${var.cluster_name}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id == "" ? aws_vpc.main[0].id : var.vpc_id

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
  vpc_id = var.vpc_id == "" ? aws_vpc.main[0].id : var.vpc_id

  tags = var.tags
}

resource "aws_default_route_table" "example" {
  default_route_table_id = var.vpc_id == "" ? aws_vpc.main[0].default_route_table_id : "${var.vpc_id}.default_route_table_id"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = var.tags
}


resource "aws_route53_zone" "main" {
  name = "${var.route53_zone}"

  vpc {
    vpc_id = var.vpc_id == "" ? aws_vpc.main[0].id : var.vpc_id
  }

  tags = var.tags
}

resource "aws_route53_record" "floating-ips" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.cluster_name}.${var.route53_zone}"
  type    = "A"
  ttl     = 1
  records = local.floating_ip_list
}

resource "aws_route53_record" "persistent-ips" {
  count   = var.node_count
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.cluster_name}-${count.index + 1}.${var.route53_zone}"
  type    = "A"
  ttl     = 3600
  records = [local.persistent_ip_list["${count.index}"]]
}
