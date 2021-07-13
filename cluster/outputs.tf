output "instance_ids" {
  value       = local.all_nodes.*.id
  description = "EC2 Instance IDs for all nodes in the cluster"
}

output "private_ips" {
  value       = local.all_nodes.*.private_ip
  description = "EC2 instance private IPs"
}

output "public_ips" {
  value       = local.all_nodes.*.public_ip
  description = "EC2 instance public IPs (if set)"
}

output "temp_admin_password" {
  value       = aws_instance.leader_node.id
  description = "Temporary admin password for the Web UI and API"
}

output "subnet_main" {
  value = aws_subnet.main.id
}

output "security_group_main" {
  value = [aws_security_group.main.id]
}
