variable "account-id" {}

module "cyber-security-audit-role" {
  source = "git::https://github.com/alphagov/tech-ops//cyber-security/modules/gds_security_audit_role?ref=c363ba60ca1ab491560bcd5a74f1ec0b62e1f0e4"

  chain_account_id = "${var.account-id}"
}
