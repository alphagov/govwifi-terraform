# GovWifi Slack Alert

This module creates the AWS chatbot, subscriptions and other supporting infrastructure for the Govwifi Slack alerts in the "govwifi-monitoring" channel.

It creates the AWS chatbot through a cloudformation stack. This is because terraform does not provide functionality for creating this feature at the time of writing.

The module should only be run in the `wifi-london` environment
