resource "null_resource" "cluster" {
  connection {
    host        = aws_instance.leader_node.public_ip
    type        = "ssh"
    user        = "admin"
    private_key = file("./bulualan2.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo qq network_mod_network --network-id 1 --floating-ip-range '${var.floating_ips}'",
    ]
  }
}
