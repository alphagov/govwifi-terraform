variable "users" {
  type        = list(any)
  description = "The list of linux users and their ssh keys allowed to access the infrastructure."

  default = []
}
