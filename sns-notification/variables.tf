variable "env-name" {
  type = string
}

variable "topic-name" {
  type = string
}

variable "emails" {
  type    = list(string)
  default = []
}

