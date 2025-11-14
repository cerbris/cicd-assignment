#!/bin/bash

# Script to add WebEx Webhook URL to Jenkins credentials

JENKINS_URL="http://jenkins.15.204.74.157.nip.io"
USERNAME="test"
API_TOKEN="11387b0d3c76481f817e137d8b8956048e"

echo "========================================"
echo "  Add WebEx Webhook to Jenkins"
echo "========================================"
echo ""

# Prompt for WebEx webhook URL
read -p "Enter your WebEx webhook URL: " WEBEX_URL

if [ -z "$WEBEX_URL" ]; then
    echo "❌ Error: WebEx URL cannot be empty"
    exit 1
fi

echo ""
echo "Adding credential to Jenkins..."

# Create credential XML
cat > /tmp/webex-credential.xml << EOF
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>webex-webhook-url</id>
  <description>WebEx Webhook for Build Notifications</description>
  <username>webex</username>
  <password>$WEBEX_URL</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
EOF

# Add credential
RESULT=$(curl -u "$USERNAME:$API_TOKEN" -X POST \
  "$JENKINS_URL/credentials/store/system/domain/_/createCredentials" \
  -H "Content-Type: application/xml" \
  --data-binary @/tmp/webex-credential.xml 2>&1)

if [[ $RESULT == *"error"* ]] || [[ $RESULT == *"Error"* ]]; then
    echo "❌ Failed to add credential"
    echo "$RESULT"
else
    echo "✅ WebEx credential added successfully!"
    echo ""
    echo "Credential ID: webex-webhook-url"
    echo "You can now run builds and WebEx notifications will work!"
fi

# Clean up
rm -f /tmp/webex-credential.xml

echo ""
