resource "aws_iam_user_policy" "dashboard-staging-read-only-user_dashboard-staging-read-only-policy" {
  name = "dashboard-staging-read-only-policy"
  user = "dashboard-staging-read-only-user"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-metrics-bucket/*"
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-staging-metrics-bucket"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy" "dashboard-wifi-read-only-user_dashboard-wifi-read-only-policy" {
  name = "dashboard-wifi-read-only-policy"
  user = "dashboard-wifi-read-only-user"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-metrics-bucket/*"
    },
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wifi-metrics-bucket"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy" "govwifi-jenkins-deploy_can-restart-ecs-services" {
  name = "can-restart-ecs-services"
  user = "govwifi-jenkins-deploy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "ecs:*",
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy" "govwifi-jenkins-deploy_read-wordlist-policy" {
  name = "read-wordlist-policy"
  user = "govwifi-jenkins-deploy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucketVersions",
        "s3:GetBucketVersioning",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::govwifi-wordlist"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": "arn:aws:s3:::govwifi-wordlist/*"
    }
  ]
}
POLICY

}

resource "aws_iam_user_policy" "jenkins-read-wordlist-user_jenkins-read-wordlist-policy" {
  name = "jenkins-read-wordlist-policy"
  user = "jenkins-read-wordlist-user"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govwifi-wordlist/wordlist-short"
    }
  ]
}
POLICY

}

