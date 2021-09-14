resource "aws_key_pair" "govwifi-bastion-key" {
  count      = var.create_production_bastion_key
  key_name   = var.govwifi-bastion-key-name
  public_key = var.govwifi-bastion-key-pub
}

resource "aws_key_pair" "govwifi-staging-bastion-key" {
  count      = var.is_production_aws_account ? 1 : 0
  key_name   = "govwifi-staging-bastion-key-20181025"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8WewWSMURrvhOpkS6pqwuQwwGtdSSjfIrAR62LRhuEjhOfPymK4eUCdK1lRQJqc/dIy09oRqaPLxT0UM9/lkwcLpBsu6/pSijNKUkGPEl0fGrzmf2RVqjFM7CSW6zSDTRW19Tn1yHsQE3shGYdVz5VyqAI2ggx/9m0d3kK+1OpJluMdjGTZNBGcs393Liinbtgl+P6BUe5yNZ8E1MTOeB0pMlbOZ5UI20f6iXRcYAkoqm6qPhzhr1Ua1MDgnn9Sd/N8cqAXApkWvYZ34oObEysRD33Qwm4OOb1geklZ8dp4JDmlG7BPkwJ5udkGh75FNmtAnLxILSa8aM+1mbvPNz staging-bastion@govwifi"
}
