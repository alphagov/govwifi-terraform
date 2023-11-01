config {
  module = false
}

plugin "aws" {
    enabled = true
    version = "0.27.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}
