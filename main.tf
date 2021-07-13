module "qumulo_cluster" {
  source        = "./cluster"
  aws_region    = "us-east-1"
  aws_az        = "us-east-1a"
  node_type     = "af"
  cluster_name  = "berat-qumulo"
  instance_type = "m5.xlarge"
  node_count    = 4
  key_pair_name = "bulualan2"
  #vpc = ""
  subnet_id          = module.qumulo_cluster.subnet_main
  security_group_ids = module.qumulo_cluster.security_group_main
  cidr_block         = "10.0.0.0/16"
  floating_ips = "10.0.0.9-20"
}
