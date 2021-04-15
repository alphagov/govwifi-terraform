import boto3

def lambda_handler(event, context):
    # Create CloudWatch client
    cloudwatch = boto3.client('cloudwatch')

    # Disable alarm
    cloudwatch.disable_alarm_actions(
        AlarmNames=['wifi-rr-lagging-alarm'],
    )
