# Radius Unknown Client

Whenever FreeRadius receives an authentication or accounting request from an 
IP it doesn't recognise, it writes to the Docker log details of this error.

CloudWatch is configured with an alarm which monitors these log entries.

An example of an alarm being raised looks like the following:

> You are receiving this email because your Amazon CloudWatch Alarm 
> "RADIUS-unknown-client" in the EU (London) region has entered the ALARM 
> state, because "Threshold Crossed: 1 out of the last 1 datapoints [1.0 
> (19/03/18 00:13:00)] was greater than the threshold (0.0) (minimum 1 
> datapoint for OK -> ALARM transition)." at "Monday 19 March, 2018 01:13:25 
> UTC". 


You can debug this via the following command:

```shell
make wifi-london get-unknown-clients
```

Note: The use of `wifi-london` matches the region in the alarm message

Which will give output looking similar to the following:

```shell
./scripts/get-unknown-clients.sh
Region       : eu-west-2
Start date   : 1d ago
Target port  : 1812
Rejected IPs : 
  61 x.x.x.x
   9 y.y.y.y
   8 z.z.z.z
```

The `whois` command can be used to identify who is making these requests.

It could be that the organisation configured the site today, and they need to
 wait for FreeRadius to reload site list configuration.

It could alternatively be that the organisation has failed to 
[register the site][register-a-site] and requires prompting.  An organisation
may not be aware of this misconfiguration until an end user reports the 
problem to them.

[register-a-site]: https://www.gov.uk/guidance/set-up-govwifi-on-your-infrastructure#step-3---register-your-site-for-govwifi
