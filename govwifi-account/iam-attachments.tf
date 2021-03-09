##########
# ROLE
##########

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/AWSLambdaBasicExecutionRole-164db990-7033-4bb4-aaed-380d56e59518"
  groups     = []
  users      = []
  roles      = ["StagingMetricsAggregator-prototype-role-saci182v"]
}

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/AWSLambdaBasicExecutionRole-9d382291-dcd5-4d68-8a4d-aef9bab6e0b5"
  groups     = []
  users      = []
  roles      = ["AggregateStagingMetrics-role-gej26flk"]
}

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/AWSLambdaBasicExecutionRole-e112f67b-c533-4923-98f7-38c38c5e51dc"
  groups     = []
  users      = []
  roles      = ["GovWifiMetricsAggregationPrototype-role-ayhlh17x"]
}

resource "aws_iam_policy_attachment" "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568-policy-attachment" {
  name       = "CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/CloudTrailPolicyForCloudWatchLogs_dab06026-75de-4ad1-a922-e4fc41e01568"
  groups     = []
  users      = []
  roles      = ["CloudTrail_CloudWatchLogs_Role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-dublin-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-staging-dublin-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-staging-dublin-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-dublin-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-staging-dublin-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-staging-dublin-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-london-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-staging-london-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-staging-london-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-staging-london-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-staging-london-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-staging-london-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-dublin-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-dublin-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-wifi-dublin-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-dublin-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-dublin-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-dublin-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-wifi-dublin-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-london-accesslogs-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-london-accesslogs-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-wifi-london-accesslogs-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-london-accesslogs-replication-role"]
}

resource "aws_iam_policy_attachment" "govwifi-wifi-london-tfstate-replication-policy-policy-attachment" {
  name       = "govwifi-wifi-london-tfstate-replication-policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/govwifi-wifi-london-tfstate-replication-policy"
  groups     = []
  users      = []
  roles      = ["govwifi-wifi-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-dublin-tfstate_to_govwifi-staging"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_for_govwifi-staging-ireland-accesslogs_to_govwifi-staging-london-accesslogs"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-ireland-accesslogs_to_govwifi-sta"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_for_govwifi-staging-london-accesslogs_to_govwifi-staging-ireland-accesslogs"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-london-accesslogs_to_govwifi-stag"]
}

resource "aws_iam_policy_attachment" "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment" {
  name       = "s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_govwifi-staging-london-tfstate_to_govwifi-staging"]
}

resource "aws_iam_policy_attachment" "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica-policy-attachment" {
  name       = "s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replica"
  groups     = []
  users      = []
  roles      = ["s3crr_role_for_test-wifi-mfadelete_to_test-wifi-mfadelete-replic"]
}

resource "aws_iam_policy_attachment" "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment" {
  name       = "s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_kms_for_govwifi-staging-dublin-tfstate_to_govwifi-staging-london-tfstate"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-dublin-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment" {
  name       = "s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/service-role/s3crr_kms_for_govwifi-staging-london-tfstate_to_govwifi-staging-dublin-tfstate"
  groups     = []
  users      = []
  roles      = ["govwifi-staging-london-tfstate-replication-role"]
}

resource "aws_iam_policy_attachment" "AutoScalingServiceRolePolicy-policy-attachment" {
  name       = "AutoScalingServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AutoScalingServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForAutoScaling"]
}

resource "aws_iam_policy_attachment" "AmazonGuardDutyServiceRolePolicy-policy-attachment" {
  name       = "AmazonGuardDutyServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonGuardDutyServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForAmazonGuardDuty"]
}

resource "aws_iam_policy_attachment" "CloudWatchFullAccess-policy-attachment" {
  name       = "CloudWatchFullAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  groups     = []
  users      = []
  roles      = ["StagingMetricsAggregator-prototype-role-saci182v"]
}

resource "aws_iam_policy_attachment" "AWSElasticLoadBalancingServiceRolePolicy-policy-attachment" {
  name       = "AWSElasticLoadBalancingServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSElasticLoadBalancingServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForElasticLoadBalancing"]
}

resource "aws_iam_policy_attachment" "ElastiCacheServiceRolePolicy-policy-attachment" {
  name       = "ElastiCacheServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/ElastiCacheServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForElastiCache"]
}

resource "aws_iam_policy_attachment" "AmazonRDSServiceRolePolicy-policy-attachment" {
  name       = "AmazonRDSServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonRDSServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForRDS"]
}

resource "aws_iam_policy_attachment" "AWSOrganizationsServiceTrustPolicy-policy-attachment" {
  name       = "AWSOrganizationsServiceTrustPolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSOrganizationsServiceTrustPolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForOrganizations"]
}

resource "aws_iam_policy_attachment" "AmazonECSServiceRolePolicy-policy-attachment" {
  name       = "AmazonECSServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForECS"]
}

resource "aws_iam_policy_attachment" "AWSSupportServiceRolePolicy-policy-attachment" {
  name       = "AWSSupportServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSSupportServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForSupport"]
}

resource "aws_iam_policy_attachment" "AWSApplicationAutoscalingECSServicePolicy-policy-attachment" {
  name       = "AWSApplicationAutoscalingECSServicePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSApplicationAutoscalingECSServicePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForApplicationAutoScaling_ECSService"]
}

resource "aws_iam_policy_attachment" "AmazonECSTaskExecutionRolePolicy-policy-attachment" {
  name       = "AmazonECSTaskExecutionRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  groups     = []
  users      = []
  roles      = ["ecsTaskExecutionRole-production-London", "admin-ecsTaskExecutionRole-production-London", "ecsTaskExecutionRole-production-dublin", "ecsTaskExecutionRole-staging-London", "admin-ecsTaskExecutionRole-staging-London", "ecsTaskExecutionRole-staging-Dublin"]
}

resource "aws_iam_policy_attachment" "AWSTrustedAdvisorServiceRolePolicy-policy-attachment" {
  name       = "AWSTrustedAdvisorServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSTrustedAdvisorServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForTrustedAdvisor"]
}

resource "aws_iam_policy_attachment" "AWSSecurityHubServiceRolePolicy-policy-attachment" {
  name       = "AWSSecurityHubServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSSecurityHubServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForSecurityHub"]
}

resource "aws_iam_policy_attachment" "AmazonRDSEnhancedMonitoringRole-policy-attachment" {
  name       = "AmazonRDSEnhancedMonitoringRole-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  groups     = []
  users      = []
  roles      = ["rds-monitoring-role", "test-staging-rds-role"]
}

resource "aws_iam_policy_attachment" "CloudTrailServiceRolePolicy-policy-attachment" {
  name       = "CloudTrailServiceRolePolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/CloudTrailServiceRolePolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForCloudTrail"]
}

resource "aws_iam_policy_attachment" "AWSGlobalAcceleratorSLRPolicy-policy-attachment" {
  name       = "AWSGlobalAcceleratorSLRPolicy-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSGlobalAcceleratorSLRPolicy"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForGlobalAccelerator"]
}

resource "aws_iam_policy_attachment" "CloudWatch-CrossAccountAccess-policy-attachment" {
  name       = "CloudWatch-CrossAccountAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/CloudWatch-CrossAccountAccess"
  groups     = []
  users      = []
  roles      = ["AWSServiceRoleForCloudWatchCrossAccount"]
}

##########
# USER
##########

#resource "aws_iam_policy_attachment" "LambdaUpdateFunctionCode-policy-attachment" {
#  name       = "LambdaUpdateFunctionCode-policy-attachment"
#  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/LambdaUpdateFunctionCode"
#  groups     = []
#  users      = ["govwifi-jenkins-deploy"]
#  roles      = []
#}
resource "aws_iam_user_policy_attachment" "LambdaUpdateFunctionCode-policy-attachment_govwifi-jenkins-deploy" {
  user        = "govwifi-jenkins-deploy"
  policy_arn  = "arn:aws:iam::${var.aws-account-id}:policy/LambdaUpdateFunctionCode"
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerServiceEventsRole-policy-attachment" {
  name       = "AmazonEC2ContainerServiceEventsRole-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
  groups     = []
  users      = ["govwifi-jenkins-deploy"]
  roles      = []
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerRegistryPowerUser-policy-attachment" {
  name       = "AmazonEC2ContainerRegistryPowerUser-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  groups     = []
  users      = ["govwifi-jenkins-deploy"]
  roles      = []
}

##########
# GROUP
##########

resource "aws_iam_policy_attachment" "GovWifi-Admin-policy-attachment" {
  name       = "GovWifi-Admin-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Admin"
  groups     = ["GovWifi-Admin"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Admin-S3-Policy-policy-attachment" {
  name       = "GovWifi-Admin-S3-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Admin-S3-Policy"
  groups     = ["GovWifi-Admin"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Audit-policy-attachment" {
  name       = "GovWifi-Audit-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Audit"
  groups     = ["GovWifi-Audit"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Developers-policy-attachment" {
  name       = "GovWifi-Developers-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Developers"
  groups     = ["GovWifi-Developers"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "GovWifi-Support-policy-attachment" {
  name       = "GovWifi-Support-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/GovWifi-Support"
  groups     = ["GovWifi-Support"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "ITHC-Access-Key-Policy-policy-attachment" {
  name       = "ITHC-Access-Key-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/ITHC-Access-Key-Policy"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = []
}

resource "aws_iam_policy_attachment" "ITHC-Staging-Cyberis-Policy-policy-attachment" {
  name       = "ITHC-Staging-Cyberis-Policy-policy-attachment"
  policy_arn = "arn:aws:iam::${var.aws-account-id}:policy/ITHC-Staging-Cyberis-Policy"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = []
}

##########
### MULTI
##########

resource "aws_iam_policy_attachment" "ReadOnlyAccess-policy-attachment" {
  name       = "ReadOnlyAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  groups     = ["ITHC-RO-SecAud-Group", "Read-Only-Access"]
  users      = []
  roles      = ["ITHC-RO-SecAud-Access", "sebastian.szypowicz-readonly", "colin.burn-murdoch-readonly"]
}

resource "aws_iam_policy_attachment" "AdministratorAccess-policy-attachment" {
  name       = "AdministratorAccess-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  groups     = ["GDS-IT-Developers", "AWS-Admin", "GDS-IT-Networks"]
  users      = []
  roles      = ["camille.descartes-admin", "ian.nicholls-admin", "chris.banks-admin", "charles.chani-admin", "stephen.ford-admin", "sarah.young-admin", "frederic.francois-admin", "jos.koetsier-admin", "tom.whitwell-admin", "roch.trinque-admin", "GDSAdminAccessGovWifi"]
}

resource "aws_iam_policy_attachment" "SecurityAudit-policy-attachment" {
  name       = "SecurityAudit-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  groups     = ["ITHC-RO-SecAud-Group"]
  users      = []
  roles      = ["ITHC-RO-SecAud-Access"]
}

##########
### END
##########
