#!/bin/bash

# Script to test WebEx webhook

echo "=================================================="
echo "WebEx Webhook Tester"
echo "=================================================="

# Prompt for webhook URL
echo "Enter your WebEx Webhook URL:"
read -r WEBHOOK_URL

if [ -z "$WEBHOOK_URL" ]; then
    echo "❌ Error: Webhook URL cannot be empty"
    exit 1
fi

echo ""
echo "Sending test message to WebEx..."

# Send test message
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "markdown": "# 🧪 Test Message\n\n**WebEx webhook is working!** ✅\n\nThis is a test from the CI/CD assignment setup.\n\n- Timestamp: '"$(date '+%Y-%m-%d %H:%M:%S')"'\n- Sent from: test-webex.sh script"
  }')

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Success! Test message sent to WebEx"
    echo ""
    echo "Check your WebEx space for the message!"
else
    echo "❌ Error: Failed to send message"
    echo "HTTP Status Code: $HTTP_CODE"
    echo ""
    echo "Please verify:"
    echo "1. Webhook URL is correct"
    echo "2. Webhook is still active in WebEx"
    echo "3. You have internet connection"
fi

echo "=================================================="
