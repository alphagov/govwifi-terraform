resource "aws_key_pair" "govwifi-bastion-key" {
  count      = var.create_production_bastion_key
  key_name   = var.govwifi-bastion-key-name
  public_key = var.govwifi-bastion-key-pub   
}

# resource "aws_key_pair" "govwifi-staging-bastion-key" {
#   key_name   = "govwifi-staging-bastion-key-20181025"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8WewWSMURrvhOpkS6pqwuQwwGtdSSjfIrAR62LRhuEjhOfPymK4eUCdK1lRQJqc/dIy09oRqaPLxT0UM9/lkwcLpBsu6/pSijNKUkGPEl0fGrzmf2RVqjFM7CSW6zSDTRW19Tn1yHsQE3shGYdVz5VyqAI2ggx/9m0d3kK+1OpJluMdjGTZNBGcs393Liinbtgl+P6BUe5yNZ8E1MTOeB0pMlbOZ5UI20f6iXRcYAkoqm6qPhzhr1Ua1MDgnn9Sd/N8cqAXApkWvYZ34oObEysRD33Qwm4OOb1geklZ8dp4JDmlG7BPkwJ5udkGh75FNmtAnLxILSa8aM+1mbvPNz staging-bastion@govwifi"
# }
#
# resource "aws_key_pair" "govwifi-bastion-key" {
#   count      = var.create_production_bastion_key
#   key_name   = "govwifi-bastion-key-20210630"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY/Q676Tp5CTpKWVksMPztERDdjWOrYFgVckF9IHGI2wC38ckWFiqawsEZBILUyNZgL/lnOtheN1UZtuGmUUkPxgtPw+YD6gMDcebhSX4wh9GM3JjXAIy9+V/WagQ84Pz10yIp+PlyzcQMu+RVRVzWyTYZUdgMsDt0tFdcgMgUc7FkC252CgtSZHpLXhnukG5KG69CoTO+kuak/k3vX5jwWjIgfMGZwIAq+F9XSIMAwylCmmdE5MetKl0Wx4EI/fm8WqSZXj+yeFRv9mQTus906AnNieOgOrgt4D24/JuRU1JTlZ35iNbOKcwlOTDSlTQrm4FA1sCllphhD/RQVYpMp6EV3xape626xwkucCC2gYnakxTZFHUIeWfC5aHGrqMOMtXRfW0xs+D+vzo3MCWepdIebWR5KVhqkbNUKHBG9e8oJbTYUkoyBZjC7LtI4fgB3+blXyFVuQoAzjf+poPzdPBfCC9eiUJrEHoOljO9yMcdkBfyW3c/o8Sd9PgNufc= bastion@govwifi"
# }
