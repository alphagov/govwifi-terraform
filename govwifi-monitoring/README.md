# GovWifi Monitoring

This module creates the SNS topics, subscriptions and other supporting infrastructure for the Govwifi Slack notifications in the "govwifi-monitoring" channel.

It does not however create the AWS chatbot Slack connection itself. This is because terraform does not provide functionality for this at the time of writing.

This module should only be run in Wifi London

In order to create the Slack/Chatbot connection please follow the steps below:
1.
2.
3.

This module should only be run after the following modules have been applied:
-  critical-notifications
