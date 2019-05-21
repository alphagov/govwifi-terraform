# Radius Shared Secret is Incorrect

Whenever FreeRadius receives an authentication or accounting request from an
IP it recognises, but the shared secret used by the IP does not match with the
one for the IP in the clients list loaded at the startup of the FreeRadius server,
it writes this error type to standard out. Since RADIUS is the main process of the
frontend container, this will be exported as the docker logs to CloudWatch.

CloudWatch is configured with an alarm which monitors these log entries.

An example of an alarm being raised looks like the following:

> You are receiving this email because your Amazon CloudWatch Alarm
> "Shared-secret-is-incorrect" in the EU (London) region has entered the ALARM
> state, because "Threshold Crossed: 1 datapoint [2.0 (18/03/18 07:14:00)]
> was greater than or equal to the threshold (1.0)." at "Monday 19 March, 2018
> 07:14:52 UTC".

It could be that the Access Point (AP) or Wireless Lan Controller (WLC) has
configuration saved for a different site, so the wrong secret is added.

Alternatively it could be that the organisation made a mistake when setting up
their AP / WLC.

In either case the organisation may not be aware of this problem until an end
user reports connectivity issues to them.

[register-a-site]: https://www.gov.uk/guidance/set-up-govwifi-on-your-infrastructure#step-3---register-your-site-for-govwifi
