#!/bin/bash

# Get the GitHub webhook URL from ngrok

echo "========================================"
echo "  GitHub Webhook Configuration"
echo "========================================"
echo ""

# Check if ngrok is running
if ! curl -s http://localhost:4040/api/tunnels > /dev/null 2>&1; then
    echo "❌ Error: ngrok is not running!"
    echo ""
    echo "Please start ngrok first:"
    echo "  ./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite"
    exit 1
fi

# Get the public URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Error: Could not get ngrok URL"
    echo ""
    echo "Make sure ngrok is running and try again"
    exit 1
fi

echo "✅ ngrok is running!"
echo ""
echo "Your ngrok public URL:"
echo "  $NGROK_URL"
echo ""
echo "========================================"
echo "  GitHub Webhook Configuration"
echo "========================================"
echo ""
echo "Use this URL for GitHub webhook:"
echo ""
echo "  ${NGROK_URL}/github-webhook/"
echo ""
echo "⚠️  IMPORTANT: Include the /github-webhook/ and trailing slash!"
echo ""
echo "Steps to configure webhook in GitHub:"
echo "1. Go to your repository → Settings → Webhooks → Add webhook"
echo "2. Payload URL: ${NGROK_URL}/github-webhook/"
echo "3. Content type: application/json"
echo "4. Events: Just the push event"
echo "5. Active: ✓ Checked"
echo "6. Click 'Add webhook'"
echo ""
echo "ngrok Web Interface: http://127.0.0.1:4040"
echo ""
