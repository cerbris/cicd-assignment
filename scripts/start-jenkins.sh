#!/bin/bash

# Script to start Jenkins with Docker Compose

set -e

echo "=================================================="
echo "Starting Jenkins for CI/CD Assignment"
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running"
    echo "Please start Docker and try again"
    exit 1
fi

# Navigate to project directory
cd "$(dirname "$0")/.."

echo "✓ Docker is running"

# Check if Jenkins container exists
if docker ps -a | grep -q jenkins-cicd; then
    echo "ℹ️  Jenkins container already exists"

    # Check if it's running
    if docker ps | grep -q jenkins-cicd; then
        echo "✓ Jenkins is already running"
    else
        echo "Starting existing Jenkins container..."
        docker start jenkins-cicd
    fi
else
    echo "Creating and starting Jenkins container..."
    docker-compose up -d
fi

echo ""
echo "Waiting for Jenkins to start..."
sleep 10

# Wait for Jenkins to be ready
MAX_WAIT=60
WAITED=0
until curl -s http://localhost:8080 > /dev/null 2>&1 || [ $WAITED -eq $MAX_WAIT ]; do
    echo -n "."
    sleep 2
    WAITED=$((WAITED + 2))
done

echo ""

if [ $WAITED -eq $MAX_WAIT ]; then
    echo "⚠️  Jenkins might still be starting up..."
    echo "Please wait a moment and check http://localhost:8080"
else
    echo "✅ Jenkins is running!"
fi

echo ""
echo "=================================================="
echo "Jenkins Information"
echo "=================================================="
echo "URL: http://localhost:8080"
echo ""

# Check if this is first run
if docker exec jenkins-cicd test -f /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null; then
    echo "Initial Admin Password:"
    echo "=================================================="
    docker exec jenkins-cicd cat /var/jenkins_home/secrets/initialAdminPassword
    echo "=================================================="
    echo ""
    echo "Copy this password to complete Jenkins setup at http://localhost:8080"
else
    echo "Jenkins is already configured"
    echo "Login at: http://localhost:8080"
fi

echo ""
echo "To view logs: docker logs -f jenkins-cicd"
echo "To stop Jenkins: docker-compose down"
echo "=================================================="
