# WebEx Bot Setup Guide

## Step 1: Create a WebEx Account

1. Go to https://www.webex.com/
2. Sign up for a free account if you don't have one
3. Verify your email address

## Step 2: Create a WebEx Space

1. Open WebEx Teams application or web interface
2. Click on **Spaces** or **+** to create a new space
3. Name it something like "Jenkins CI/CD Notifications"
4. This is where you'll receive build notifications

## Step 3: Create an Incoming Webhook

### Method 1: Using WebEx Developer Portal

1. Go to https://developer.webex.com/
2. Sign in with your WebEx account
3. Click on **Documentation** > **API Reference**
4. Navigate to **Webhooks** section

### Method 2: Create Webhook via API (Recommended)

1. **Get your Personal Access Token**:
   - Go to https://developer.webex.com/docs/getting-started
   - Click on your profile icon (top right)
   - Click **Copy** next to your Personal Access Token
   - Save this token securely!

2. **Get your Room/Space ID**:

First, list all your spaces:

```bash
curl -X GET \
  https://webexapis.com/v1/rooms \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  | jq '.'
```

Find the `id` of your "Jenkins CI/CD Notifications" space.

3. **Create an Incoming Webhook**:

```bash
curl -X POST \
  https://webexapis.com/v1/webhooks \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Jenkins Build Notifications",
    "targetUrl": "https://example.com/webhook",
    "resource": "messages",
    "event": "created",
    "filter": "roomId=YOUR_ROOM_ID"
  }'
```

**Note**: This creates a webhook that listens for messages. For sending notifications, we need an **Incoming Webhook**.

### Method 3: Using WebEx Teams UI (Easiest)

1. Open your WebEx Teams space
2. Click on the space name at the top
3. Click on **Apps**
4. Search for "Incoming Webhooks"
5. Click **Add**
6. Give it a name: "Jenkins Build Bot"
7. Copy the **Webhook URL** - this is what you'll use in Jenkins!

The webhook URL will look like:
```
https://webexapis.com/v1/webhooks/incoming/Y2lzY...
```

## Step 4: Alternative - Create a WebEx Bot

If you want more control:

1. Go to https://developer.webex.com/my-apps
2. Click **Create a New App**
3. Select **Create a Bot**
4. Fill in the details:
   - Bot name: Jenkins CI/CD Bot
   - Bot username: jenkins-cicd-bot
   - Icon: Upload an icon or use default
   - Description: Sends Jenkins build notifications
5. Click **Add Bot**
6. **Save the Bot Access Token** - you'll need this!

## Step 5: Test the Webhook

Test your webhook with curl:

```bash
# Replace with your webhook URL
WEBHOOK_URL="https://webexapis.com/v1/webhooks/incoming/YOUR_WEBHOOK_ID"

# Send a test message
curl -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "markdown": "# Test Message\n\nThis is a test from Jenkins setup!"
  }'
```

Check your WebEx space - you should see the message!

## Step 6: Configure Webhook in Jenkins

1. In Jenkins, go to **Manage Jenkins** > **Manage Credentials**
2. Add new credential:
   - Kind: **Secret text**
   - Secret: Paste your WebEx Webhook URL
   - ID: `webex-webhook-url`
   - Description: WebEx Webhook URL

## Step 7: Test from Jenkins

Create a test pipeline in Jenkins:

```groovy
pipeline {
    agent any

    environment {
        WEBEX_WEBHOOK_URL = credentials('webex-webhook-url')
    }

    stages {
        stage('Test WebEx Notification') {
            steps {
                sh '''
                    curl -X POST $WEBEX_WEBHOOK_URL \
                    -H "Content-Type: application/json" \
                    -d "{
                        \\"markdown\\": \\"# Jenkins Test\\\\n\\\\nWebEx integration is working! ✅\\"
                    }"
                '''
            }
        }
    }
}
```

Run this pipeline and check your WebEx space for the notification!

## Message Formatting

WebEx supports Markdown formatting:

```json
{
  "markdown": "# Heading\n\n**Bold text**\n\n*Italic text*\n\n- Bullet point\n\n[Link](https://example.com)"
}
```

### Rich Build Notifications

Example notification format:

```json
{
  "markdown": "✅ **Jenkins Build SUCCESS**\n\n**Job:** my-pipeline\n\n**Build #:** 42\n\n**Branch:** main\n\n**Commit:** abc1234\n\n**URL:** https://jenkins.example.com/job/my-pipeline/42/"
}
```

## Troubleshooting

### Webhook not working:

1. **Verify webhook URL**:
```bash
# List all your webhooks
curl -X GET \
  https://webexapis.com/v1/webhooks \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

2. **Check webhook status**:
```bash
curl -X GET \
  https://webexapis.com/v1/webhooks/WEBHOOK_ID \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

3. **Delete and recreate webhook**:
```bash
curl -X DELETE \
  https://webexapis.com/v1/webhooks/WEBHOOK_ID \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### Message not appearing:

- Check if webhook URL is correct
- Verify the space/room ID
- Ensure the bot is added to the space
- Check Jenkins credentials configuration

### Authentication errors:

- Verify your access token is valid
- Check if token has expired (Personal Access Tokens expire after 12 hours)
- Regenerate token if needed

## Best Practices

1. **Use Incoming Webhooks** for simplicity (no authentication needed)
2. **Store webhook URL securely** in Jenkins credentials
3. **Test webhook** before integrating with pipeline
4. **Use markdown formatting** for better readability
5. **Include relevant information**: Job name, build number, status, commit info, build URL

## Resources

- WebEx Developer Documentation: https://developer.webex.com/docs/api/basics
- Incoming Webhooks Guide: https://developer.webex.com/docs/integrations
- WebEx Teams: https://teams.webex.com/
- WebEx API Reference: https://developer.webex.com/docs/api/v1/webhooks

## Security Notes

- **Never commit webhook URLs** to version control
- **Use Jenkins credentials** to store sensitive information
- **Restrict access** to WebEx space
- **Consider using bot tokens** for enhanced security
- **Rotate tokens** periodically
