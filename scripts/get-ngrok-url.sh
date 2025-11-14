#!/bin/bash

# Script to get current ngrok URL

echo "=================================================="
echo "Getting ngrok URL"
echo "=================================================="

# Check if ngrok is running
if ! curl -s http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
    echo "❌ ngrok is not running"
    echo "Please start ngrok first: ./scripts/start-ngrok.sh"
    exit 1
fi

# Get ngrok URL
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Could not retrieve ngrok URL"
    echo "Please check if ngrok is running properly"
    exit 1
fi

echo "✅ ngrok is running!"
echo ""
echo "Your ngrok URL:"
echo "=================================================="
echo "$NGROK_URL"
echo "=================================================="
echo ""
echo "GitHub Webhook URL (copy this!):"
echo "=================================================="
echo "${NGROK_URL}/github-webhook/"
echo "=================================================="
echo ""
echo "⚠️  Remember to include /github-webhook/ and trailing slash!"
echo ""
echo "ngrok Web Interface: http://127.0.0.1:4040"
echo "=================================================="
