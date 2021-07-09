data "aws_ami" "qumulo_node_type" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["Qumulo-Cloud*${var.node_type}*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
