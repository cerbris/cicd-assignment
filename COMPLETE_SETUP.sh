#!/bin/bash

# Complete CI/CD Pipeline Setup Script
# This completes all remaining tasks

set -e

JENKINS_URL="http://jenkins.15.204.74.157.nip.io"
JENKINS_USER="test"
JENKINS_TOKEN="11387b0d3c76481f817e137d8b8956048e"
GITHUB_REPO="cerbris/cicd-assignment"

echo "========================================"
echo "  Complete CI/CD Pipeline Setup"
echo "========================================"
echo ""

# Check if ngrok authtoken is configured
if [ ! -f "$HOME/.config/ngrok/ngrok.yml" ]; then
    echo "⚠️  ngrok authtoken not configured yet"
    echo ""
    echo "Please:"
    echo "1. Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "2. Copy your authtoken"
    echo "3. Run: ./ngrok authtoken YOUR_TOKEN"
    echo ""
    read -p "Have you configured ngrok? (y/n): " configured

    if [ "$configured" != "y" ]; then
        echo "Please configure ngrok first, then run this script again."
        exit 1
    fi
fi

echo "✅ ngrok is configured"
echo ""

# Start ngrok in background
echo "Starting ngrok tunnel..."
pkill ngrok 2>/dev/null || true
sleep 2

./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!

echo "⏳ Waiting for ngrok to start..."
sleep 5

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Failed to get ngrok URL"
    echo "Check if ngrok is running: http://127.0.0.1:4040"
    exit 1
fi

echo "✅ ngrok tunnel running!"
echo "   URL: $NGROK_URL"
echo "   Web UI: http://127.0.0.1:4040"
echo ""

# Prepare GitHub webhook URL
WEBHOOK_URL="${NGROK_URL}/github-webhook/"

echo "========================================"
echo "  GitHub Webhook Configuration"
echo "========================================"
echo ""
echo "Use this URL for GitHub webhook:"
echo ""
echo "  $WEBHOOK_URL"
echo ""
echo "⚠️  IMPORTANT: Include the /github-webhook/ and trailing slash!"
echo ""

# Ask if user wants to continue with GitHub webhook setup
read -p "Do you want me to show you how to configure GitHub webhook? (y/n): " show_github

if [ "$show_github" == "y" ]; then
    echo ""
    echo "========================================"
    echo "  GitHub Webhook Setup Steps"
    echo "========================================"
    echo ""
    echo "1. Go to: https://github.com/$GITHUB_REPO/settings/hooks"
    echo "2. Click 'Add webhook'"
    echo "3. Payload URL: $WEBHOOK_URL"
    echo "4. Content type: application/json"
    echo "5. Events: Just the push event"
    echo "6. Active: ✓ Checked"
    echo "7. Click 'Add webhook'"
    echo ""
fi

echo "========================================"
echo "  Testing the Pipeline"
echo "========================================"
echo ""
echo "Once GitHub webhook is configured, test it:"
echo ""
echo "  cd /home/jake/cicd-assignment"
echo "  echo '# Test change' >> app.py"
echo "  git add app.py"
echo "  git commit -m 'Test: Auto-trigger via webhook'"
echo "  git push origin main"
echo ""
echo "Then watch:"
echo "  - ngrok UI: http://127.0.0.1:4040"
echo "  - Jenkins: $JENKINS_URL"
echo "  - WebEx space for notification"
echo ""

echo "========================================"
echo "  Status Summary"
echo "========================================"
echo ""
echo "✅ Jenkins: $JENKINS_URL"
echo "✅ ngrok URL: $NGROK_URL"
echo "✅ Webhook URL: $WEBHOOK_URL"
echo "✅ ngrok Web UI: http://127.0.0.1:4040"
echo ""
echo "⏳ Next: Configure GitHub webhook"
echo "⏳ Then: Test with git push"
echo "⏳ Finally: Record your demo!"
echo ""
echo "ngrok is running in background (PID: $NGROK_PID)"
echo "To stop: kill $NGROK_PID"
echo ""
