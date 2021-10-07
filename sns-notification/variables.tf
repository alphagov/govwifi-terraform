variable "topic-name" {
  type = string
}

variable "emails" {
  type    = list(string)
  default = []
}

