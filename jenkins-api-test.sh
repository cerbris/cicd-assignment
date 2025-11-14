#!/bin/bash

# Jenkins API Test Script
# This attempts to interact with Jenkins via API

JENKINS_URL="http://jenkins.15.204.74.157.nip.io"
USERNAME="test"
PASSWORD="k5CSnEWjTkJIUjO7YnbN9W3OAXbybYJA1yJYfzwNOpM8IeALa9EEWGp72BdHr2qQSHZPOYyv"

echo "Testing Jenkins API Access..."
echo "URL: $JENKINS_URL"
echo "Username: $USERNAME"
echo ""

# Try to get crumb for CSRF protection
echo "1. Getting CSRF crumb..."
CRUMB=$(curl -u "$USERNAME:$PASSWORD" -s "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" 2>&1)

if [[ $CRUMB == *"crumb"* ]]; then
    echo "   ✅ Got crumb: $CRUMB"

    # Try to access API
    echo ""
    echo "2. Testing API access..."
    curl -u "$USERNAME:$PASSWORD" -H "$CRUMB" -s "$JENKINS_URL/api/json?pretty=true" | head -30
else
    echo "   ❌ Failed to get crumb"
    echo "   Response: $CRUMB"
    echo ""
    echo "This means:"
    echo "  - Credentials might be incorrect"
    echo "  - Or Jenkins requires API token instead of password"
    echo "  - Or CSRF protection is blocking"
fi

echo ""
echo "============================================"
echo "Alternative: Generate API Token in Jenkins"
echo "============================================"
echo ""
echo "To use Jenkins API, you need to:"
echo "1. Log into Jenkins web UI"
echo "2. Click your name (top right) → Configure"
echo "3. Under 'API Token', click 'Add new Token'"
echo "4. Copy the token and use it instead of password"
echo ""
