#!/bin/bash

# Script to start ngrok tunnel to Jenkins

set -e

echo "=================================================="
echo "Starting ngrok Tunnel for Jenkins"
echo "=================================================="

# Navigate to project directory
cd "$(dirname "$0")/.."

# Check if ngrok exists
if [ ! -f "./ngrok" ]; then
    echo "❌ ngrok not found!"
    echo ""
    echo "Installing ngrok..."

    # Download ngrok
    wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

    # Extract
    tar xvzf ngrok-v3-stable-linux-amd64.tgz

    # Make executable
    chmod +x ngrok

    # Cleanup
    rm ngrok-v3-stable-linux-amd64.tgz

    echo "✓ ngrok installed"
    echo ""
    echo "⚠️  Please configure ngrok with your authtoken:"
    echo "./ngrok authtoken YOUR_AUTH_TOKEN"
    echo ""
    echo "Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo ""
    read -p "Press Enter after you've configured ngrok..."
fi

# Check if Jenkins is running
if ! curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "❌ Jenkins is not running on port 8080"
    echo "Please start Jenkins first: ./scripts/start-jenkins.sh"
    exit 1
fi

echo "✓ Jenkins is running"
echo ""
echo "Starting ngrok tunnel..."
echo "=================================================="
echo ""
echo "⚠️  IMPORTANT: Keep this terminal window open!"
echo "   ngrok must stay running for webhooks to work"
echo ""
echo "=================================================="
echo ""
echo "ngrok Web Interface: http://127.0.0.1:4040"
echo "This shows all webhook traffic in real-time"
echo ""
echo "=================================================="
echo ""

# Start ngrok
./ngrok http 8080
