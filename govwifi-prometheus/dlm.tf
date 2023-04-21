resource "aws_iam_policy_attachment" "prometheus_dlm_lifecycle" {
  count      = (var.aws_region == "eu-west-2" ? 1 : 0)
  name       = aws_iam_policy.prometheus_dlm_lifecycle[0].name
  roles      = [aws_iam_role.dlm_prometheus_lifecycle_role[0].name]
  policy_arn = aws_iam_policy.prometheus_dlm_lifecycle[0].arn
}

resource "aws_dlm_lifecycle_policy" "prometheus_ebs_volume_backup" {
  description        = "Prometheus EBS DLM lifecycle policy"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/prometheus-dlm-lifecycle-role"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Prometheus EBS Volume"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["04:00"]
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    target_tags = {
      Name = "${var.env_name} Prometheus volume"
    }
  }
}

resource "aws_dlm_lifecycle_policy" "prometheus_root_volume_backup" {
  description        = "Prometheus Root DLM lifecycle policy"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/prometheus-dlm-lifecycle-role"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Prometheus Root Volume"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["04:00"]
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    target_tags = {
      Name = "${var.env_name} Prometheus Root Volume"
    }
  }
}