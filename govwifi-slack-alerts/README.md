# GovWifi Slack Alert via ChatBot

This module creates the AWS chatbot, subscriptions and other supporting infrastructure for the Govwifi Slack alerts in the "govwifi-monitoring" and "govwifi-alerts channels.  This is determined by different SNS Topics.

It creates the AWS chatbot through a cloudformation stack. This is because terraform does not provide functionality for creating this feature at the time of writing.

The module should only be run in the `wifi-london` environment

If creating the chatbot from scratch, AWS requires that a 'chatbot configuration' is setup first.
To enable on a new account, in AWS console go to the search bar type AWS Chatbot then “configure new client”, select Slack, select the GDS channel, and Allow permissions.
