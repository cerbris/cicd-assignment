#!/bin/bash

# Quick ngrok setup script for CI/CD assignment

echo "========================================"
echo "  ngrok Setup for Jenkins CI/CD"
echo "========================================"
echo ""

# Check if ngrok exists
if [ ! -f "./ngrok" ]; then
    echo "📥 Downloading ngrok..."
    curl -o ngrok.tar.gz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
    tar -xzf ngrok.tar.gz
    chmod +x ngrok
    rm ngrok.tar.gz
    echo "✅ ngrok downloaded and extracted"
else
    echo "✅ ngrok already exists"
fi

echo ""
echo "ngrok version:"
./ngrok version

echo ""
echo "========================================"
echo "Next Steps:"
echo "========================================"
echo ""
echo "1. Get your ngrok authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
echo ""
echo "2. Configure ngrok (run this command with YOUR token):"
echo "   ./ngrok authtoken YOUR_AUTH_TOKEN"
echo ""
echo "3. Start ngrok tunnel (keep this terminal open):"
echo "   ./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite"
echo ""
echo "4. In another terminal, get your public URL:"
echo "   curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^\"]*\.ngrok-free\.app'"
echo ""
echo "5. Open ngrok web interface:"
echo "   http://127.0.0.1:4040"
echo ""
