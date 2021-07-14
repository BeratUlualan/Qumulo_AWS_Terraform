module "qumulo_cluster" {
  source             = "./cluster"
  aws_region         = "us-east-1"
  aws_az             = "us-east-1a"
  node_type          = "af"
  cluster_name       = "berat-qumulo"
  instance_type      = "m5.xlarge"
  node_count         = 4
  key_pair_name      = "bulualan2"
  vpc_id             = ""
  subnet_id          = ""
  security_group_ids = []
  cidr_block         = "10.0.0.0/16"
  persistent_ips     = "10.0.0.5-8"
  floating_ips       = "10.0.0.9-20"
  route53_zone = "test-berat.local"
}
