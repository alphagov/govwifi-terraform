resource "aws_cloudwatch_dashboard" "SLIs" {
  dashboard_name = "SLIs"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 18,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "wifi-logging-api", "wifi-radius-access-accept-count", { "period": 300, "stat": "Sum", "label": "accept-count" } ],
                    [ ".", "wifi-radius-access-reject-count", { "period": 300, "stat": "Sum", "label": "reject-count" } ],
                    [ "wifi-authorisation-api", "wifi-response-status-ok-count", { "period": 300, "stat": "Sum", "label": "ok-count" } ],
                    [ "wifi-logging-api", "wifi-response-status-no-content-count", { "period": 300, "stat": "Sum", "label": "no-content-count" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-2",
                "title": "Authentication Journey Details",
                "legend": {
                    "position": "right"
                },
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 0,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM([m1,m2])", "label": "access-count", "id": "e1", "visible": false } ],
                    [ { "expression": "e1 / m3 * 100", "label": "access-ok", "id": "e2", "visible": false } ],
                    [ { "expression": "e1 / m4 * 100", "label": "access-no-content", "id": "e3", "visible": false } ],
                    [ { "expression": "AVG([(e1 / m3), (e1 / m4)]) * 100", "label": "percentile", "id": "e4" } ],
                    [ "wifi-logging-api", "wifi-radius-access-accept-count", { "period": 604800, "stat": "Sum", "id": "m1", "label": "accept-count", "visible": false } ],
                    [ ".", "wifi-radius-access-reject-count", { "period": 604800, "stat": "Sum", "id": "m2", "label": "reject-count", "visible": false } ],
                    [ "wifi-authorisation-api", "wifi-response-status-ok-count", { "period": 604800, "stat": "Sum", "id": "m3", "label": "ok-count", "visible": false } ],
                    [ "wifi-logging-api", "wifi-response-status-no-content-count", { "period": 604800, "stat": "Sum", "id": "m4", "label": "no-content-count", "visible": false } ]
                ],
                "view": "singleValue",
                "region": "eu-west-2",
                "title": "Authentication Journey",
                "period": 300
            }
        }
    ]
}
 EOF
}
