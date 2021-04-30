variable "users" {
  type        = list
  description = "The list of linux users and their ssh keys allowed to access the infrastructure."

  default = []
}
