module "qumulo_cluster" {
  source            = ""
  ami_id            = ""  
  cluster_name      = ""
  instance_type     = ""
  node_count        = 4
  key_pair_name     = ""
  subnet_id         = ""
  security_group_ids = [""]
  tags              = {
    User = ""
    Department = ""
  }
}
