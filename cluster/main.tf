resource "aws_instance" "leader_node" {
  ami                    = data.aws_ami.qumulo_node_type.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_id == "" ? aws_subnet.main[0].id : var.subnet_id
  vpc_security_group_ids = length(var.security_group_ids) == 0 ? [aws_security_group.main[0].id] : var.security_group_ids
  private_ip             = local.persistent_ip_list[0]
  secondary_private_ips  = [local.floating_ip_list[0], local.floating_ip_list["${var.node_count}"], local.floating_ip_list["${2 * var.node_count}"]]
  tags                   = { Name = "${var.cluster_name} 1" }


  # This user_data will be used to instruct the leader_node to form a cluster
  # with the other nodes.
  user_data = jsonencode({
    node_ips     = aws_instance.node.*.private_ip
    cluster_name = var.cluster_name
  })
}

resource "aws_instance" "node" {
  count = var.node_count - 1

  ami                    = data.aws_ami.qumulo_node_type.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_id == "" ? aws_subnet.main[0].id : var.subnet_id
  vpc_security_group_ids = length(var.security_group_ids) == 0 ? [aws_security_group.main[0].id] : var.security_group_ids
  private_ip             = local.persistent_ip_list["${count.index + 1}"]
  secondary_private_ips  = [local.floating_ip_list["${count.index + 1}"], local.floating_ip_list["${count.index + 1 + var.node_count}"], local.floating_ip_list["${count.index + 1 + 2 * var.node_count}"]]
  tags                   = { Name = "${var.cluster_name} ${count.index + 2}" }
}

locals {
  all_nodes = concat([aws_instance.leader_node], aws_instance.node.*)
}
