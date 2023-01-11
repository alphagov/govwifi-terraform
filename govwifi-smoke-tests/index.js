console.log('Loading function');

const https = require('https');

const postRequest = (payload) => {

    const data = JSON.stringify(payload);
    console.log(data);

    const options = {
        hostname: 'hooks.slack.com',
        path: process.env.URL,
        port: 443,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'Content-Length': data.length
        }
    };

    return new Promise((resolve, reject) => {
        const req = https.request(options, res => {
            let rawData = '';

            res.on('data', chunk => {
                rawData += chunk;
            });

            res.on('end', () => {
                resolve({
                    statusCode: 200,
                    body: `${rawData}`
                });
            });
        });

        req.on('error', err => {
            reject(new Error(err));
        });

        req.write(data);
        req.end();
    });
};


const formatPayload = (snsRecord) => {
    return {
        blocks: [
            // As things stand, we don't need a header block but attempting this caused a series
            // of 'invalid_blocks' errors from the Slack API. If we do want one, we'll need further
            // investigation using the reference (https://api.slack.com/reference/block-kit/blocks#header)
            // and the block builder (https://app.slack.com/block-kit-builder/)
            {
                type: "section",
                fields: [
                    {
                        type: "mrkdwn",
                        text: `*${(new Date(snsRecord.Timestamp)).toUTCString()}*`
                    },
                    {
                        type: "plain_text",
                        // Next field can only be 150 chars
                        text: `${snsRecord.Message.replaceAll('"', '')}`
                    }
                ]
             }
        ]
    }
}


exports.handler = async (event) => {

    let payload = formatPayload(event.Records[0].Sns);
    const result = await postRequest(payload);
    const response = {
        statusCode: 200,
        body: result,
    };
    console.log(response);
    return response;
};
