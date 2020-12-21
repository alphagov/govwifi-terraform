# Prometheus

This module creates an EC2 instance with an attached EBS volume. It installs Prometheus, runs a Prometheus server, and saves the scraped metric data to the EBS volume.

The Prometheus server scrapes metrics from the FreeRADIUS Prometheus exporters running on the frontend containers. 

Note: `prometheus-govwifi` is a custom built unit script to override the Prometheus start-up script in systemd. 

It was necessary to override the default start-up script to ensure data was written to the EBS volume and not the default location configured in Prometheus.