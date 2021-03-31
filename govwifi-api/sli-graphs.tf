resource "aws_cloudwatch_dashboard" "SLIs" {
  dashboard_name = "SLIs-${var.Env-Name}"

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
                    [ "${var.Env-Name}-logging-api", "${var.Env-Name}-radius-access-accept-count", { "period": 300, "stat": "Sum", "label": "accept-count" } ],
                    [ ".", "${var.Env-Name}-radius-access-reject-count", { "period": 300, "stat": "Sum", "label": "reject-count" } ],
                    [ "${var.Env-Name}-authorisation-api", "${var.Env-Name}-response-status-ok-count", { "period": 300, "stat": "Sum", "label": "ok-count" } ],
                    [ "${var.Env-Name}-logging-api", "${var.Env-Name}-response-status-no-content-count", { "period": 300, "stat": "Sum", "label": "no-content-count" } ]
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
                    [ "${var.Env-Name}-logging-api", "${var.Env-Name}-radius-access-accept-count", { "period": 604800, "stat": "Sum", "id": "m1", "label": "accept-count", "visible": false } ],
                    [ ".", "${var.Env-Name}-radius-access-reject-count", { "period": 604800, "stat": "Sum", "id": "m2", "label": "reject-count", "visible": false } ],
                    [ "${var.Env-Name}-authorisation-api", "${var.Env-Name}-response-status-ok-count", { "period": 604800, "stat": "Sum", "id": "m3", "label": "ok-count", "visible": false } ],
                    [ "${var.Env-Name}-logging-api", "${var.Env-Name}-response-status-no-content-count", { "period": 604800, "stat": "Sum", "id": "m4", "label": "no-content-count", "visible": false } ]
                ],
                "view": "singleValue",
                "region": "eu-west-2",
                "title": "Authentication Journey",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 3,
            "width": 18,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "${var.Env-Name}-user-signup-api", "${var.Env-Name}-notify-sms-success-count", { "id": "m1", "period": 300, "stat": "Sum", "label": "sms-success-count" } ],
                    [ ".", "${var.Env-Name}-notify-sms-failed-count", { "id": "m2", "period": 300, "stat": "Sum", "label": "sms-failed-count" } ]
                ],
                "view": "timeSeries",
                "region": "eu-west-2",
                "stacked": false,
                "title": "Successful SMS Responses Details",
                "period": 300,
                "legend": {
                    "position": "right"
                }
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 3,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "total", "id": "e1", "visible": false } ],
                    [ { "expression": "m1 / e1 * 100", "label": "percentile", "id": "e2" } ],
                    [ "${var.Env-Name}-user-signup-api", "${var.Env-Name}-notify-sms-success-count", { "id": "m1", "visible": false, "period": 604800, "stat": "Sum", "label": "sms-success-count" } ],
                    [ ".", "${var.Env-Name}-notify-sms-failed-count", { "id": "m2", "visible": false, "period": 604800, "stat": "Sum", "label": "sms-failed-count" } ]
                ],
                "view": "singleValue",
                "region": "eu-west-2",
                "title": "Successful SMS Responses",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 18,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "${var.Env-Name}-user-signup-api", "${var.Env-Name}-notify-email-success-count", { "id": "m1", "period": 300, "stat": "Sum", "label": "email-success-count" } ],
                    [ ".", "${var.Env-Name}-notify-email-failed-count", { "id": "m2", "period": 300, "stat": "Sum", "label": "email-failed-count" } ]
                ],
                "view": "timeSeries",
                "region": "eu-west-2",
                "stacked": false,
                "title": "Successful email Responses Details",
                "period": 300,
                "legend": {
                    "position": "right"
                }
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 6,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ { "expression": "SUM(METRICS())", "label": "total", "id": "e1", "visible": false } ],
                    [ { "expression": "m1 / e1 * 100", "label": "percentile", "id": "e2" } ],
                    [ "${var.Env-Name}-user-signup-api", "${var.Env-Name}-notify-email-success-count", { "id": "m1", "visible": false, "period": 604800, "stat": "Sum", "label": "email-success-count" } ],
                    [ ".", "${var.Env-Name}-notify-email-failed-count", { "id": "m2", "visible": false, "period": 604800, "stat": "Sum", "label": "email-failed-count" } ]
                ],
                "view": "singleValue",
                "region": "eu-west-2",
                "title": "Successful email Responses",
                "period": 300
            }
        }
    ]
}
 
EOF

}

