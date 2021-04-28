variable "users" {
  type        = list(string)
  description = "The list of linux users and their ssh keys allowed to access the infrastructure."

  default = []
}
