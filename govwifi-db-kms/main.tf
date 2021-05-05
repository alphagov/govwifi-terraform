resource "aws_kms_key" "govwifi-db-key" {
  description             = "Govwifi customer managed key for encrypting database snapshots"
  enable_key_rotation     = true
  policy                  = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "govwifi--db-key-policy",
    "Statement": [
        {
            "Sid": "Allow access through RDS for all principals in the account that are authorized to use RDS",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "rds.${var.Env-Name}.amazonaws.com",
                    "kms:CallerAccount": "${var.aws-account-id}"
                }
            }
        },
        {
            "Sid": "Allow direct access to key metadata to the account",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws-account-id}:root"
            },
            "Action": [
                "kms:Describe*",
                "kms:Get*",
                "kms:List*",
                "kms:RevokeGrant"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {"AWS": [
              "arn:aws:iam::${var.aws-secondary-account-id}:root"
            ]},
            "Action": [
              "kms:CreateGrant",
              "kms:Encrypt",
              "kms:Decrypt",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*",
              "kms:DescribeKey"
            ],
            "Resource": "*"
          },
          {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {"AWS": [
              "arn:aws:iam::${var.aws-secondary-account-id}:root"
            ]},
            "Action": [
              "kms:CreateGrant",
              "kms:ListGrants",
              "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {"Bool": {"kms:GrantIsForAWSResource": true}}
          }
    ]
  }
EOF
}

resource "aws_kms_alias" "smc-kms-alias" {
  target_key_id = "${aws_kms_key.govwifi-db-key.key_id}"
  name          = "alias/staging/govwifi-db-key"
}
