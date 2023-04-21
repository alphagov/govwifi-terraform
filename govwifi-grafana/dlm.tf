
resource "aws_dlm_lifecycle_policy" "grafana_ebs_volume_backup" {
  description        = "Grafana EBS DLM lifecycle policy"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/grafana-dlm-lifecycle-role"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Grafana EBS Volume"

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
      Name = "${var.env_name} Grafana volume"
    }
  }
}

resource "aws_dlm_lifecycle_policy" "grafana_root_volume_backup" {
  description        = "Grafana Root DLM lifecycle policy"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/grafana-dlm-lifecycle-role"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "Grafana Root Volume"

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
      Name = "${var.env_name} Grafana Root Volume"
    }
  }
}