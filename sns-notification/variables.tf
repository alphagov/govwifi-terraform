variable "topic_name" {
  type = string
}

variable "emails" {
  type    = list(string)
  default = []
}

