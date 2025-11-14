#!/bin/bash

echo "========================================"
echo "  Jenkins Accessibility Test"
echo "========================================"
echo ""

JENKINS_URL="http://jenkins.15.204.74.157.nip.io"

echo "Testing Jenkins URL: $JENKINS_URL"
echo ""

# Test if Jenkins is responding
echo "1. Testing Jenkins HTTP response..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL")

if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "403" ]; then
    echo "   ✅ Jenkins is accessible (HTTP $HTTP_CODE)"
else
    echo "   ❌ Jenkins not accessible (HTTP $HTTP_CODE)"
fi

echo ""

# Check if Jenkins pod is running
echo "2. Checking Jenkins pod status..."
POD_STATUS=$(kubectl get pods -n cicd-assignment -o jsonpath='{.items[0].status.phase}')
POD_NAME=$(kubectl get pods -n cicd-assignment -o jsonpath='{.items[0].metadata.name}')

if [ "$POD_STATUS" == "Running" ]; then
    echo "   ✅ Jenkins pod is running: $POD_NAME"
else
    echo "   ❌ Jenkins pod status: $POD_STATUS"
fi

echo ""

# Check Python in Jenkins
echo "3. Checking Python installation in Jenkins..."
PYTHON_VERSION=$(kubectl exec -n cicd-assignment $POD_NAME -- python3 --version 2>&1)

if [[ $PYTHON_VERSION == *"Python 3"* ]]; then
    echo "   ✅ $PYTHON_VERSION"
else
    echo "   ❌ Python not found"
fi

echo ""

# Check if Jenkins is fully started
echo "4. Checking if Jenkins is fully initialized..."
kubectl logs -n cicd-assignment $POD_NAME --tail=5 | grep -q "Jenkins is fully up and running"

if [ $? -eq 0 ]; then
    echo "   ✅ Jenkins is fully up and running"
else
    echo "   ⏳ Jenkins may still be starting..."
fi

echo ""
echo "========================================"
echo "  Summary"
echo "========================================"
echo ""
echo "Jenkins URL: $JENKINS_URL"
echo "Password: 8c019e08475445a68a4bc66abf310a69"
echo ""
echo "Next steps:"
echo "1. Open $JENKINS_URL in your browser"
echo "2. Complete initial setup manually"
echo "3. Follow guides in ACTION_PLAN.md"
echo ""
