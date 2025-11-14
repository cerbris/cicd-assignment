#!/bin/bash

# Script to make a test commit and trigger the pipeline

set -e

echo "=================================================="
echo "CI/CD Pipeline Test"
echo "=================================================="

# Navigate to project directory
cd "$(dirname "$0")/.."

# Check if in git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repository"
    echo "Please initialize git first"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  You have uncommitted changes"
    read -p "Do you want to commit them? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted"
        exit 1
    fi
fi

echo ""
echo "Creating test commit..."

# Add timestamp to README
echo "" >> README.md
echo "### Pipeline Test" >> README.md
echo "- Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> README.md
echo "- Test: Automated pipeline trigger" >> README.md

# Commit and push
git add README.md
git commit -m "Test CI/CD pipeline - $(date '+%Y-%m-%d %H:%M:%S')"

echo ""
echo "=================================================="
echo "⚠️  IMPORTANT: Start screen recording NOW!"
echo "=================================================="
echo ""
echo "Your recording should show:"
echo "1. This terminal pushing to GitHub"
echo "2. GitHub showing commit timestamp"
echo "3. ngrok inspector showing webhook"
echo "4. Jenkins running the build"
echo "5. WebEx receiving notification"
echo ""
read -p "Press Enter when recording is started..."

echo ""
echo "Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Code pushed to GitHub!"
echo ""
echo "=================================================="
echo "Now check these in order:"
echo "=================================================="
echo ""
echo "1. GitHub Repository:"
echo "   - Go to your repository"
echo "   - Check commit timestamp (should show 'now')"
echo ""
echo "2. ngrok Inspector:"
echo "   - Open: http://127.0.0.1:4040"
echo "   - Look for POST request from GitHub"
echo ""
echo "3. Jenkins:"
echo "   - Open: http://localhost:8080"
echo "   - Check if build is triggered"
echo "   - View console output"
echo ""
echo "4. WebEx:"
echo "   - Check your WebEx space"
echo "   - Should receive build notification"
echo ""
echo "=================================================="
echo "Make sure to record all of these!"
echo "=================================================="
