# Complete CI/CD Pipeline Setup Guide

This guide will walk you through setting up the entire CI/CD pipeline from scratch.

## Prerequisites

- Linux system (Arch Linux, Ubuntu, etc.)
- Docker and Docker Compose installed
- Git installed
- Internet connection
- GitHub account
- WebEx account

## Quick Start Checklist

- [ ] 1. Create GitHub repository
- [ ] 2. Push code to GitHub
- [ ] 3. Start Jenkins in Docker
- [ ] 4. Configure Jenkins
- [ ] 5. Start ngrok tunnel
- [ ] 6. Create WebEx webhook
- [ ] 7. Configure GitHub webhook
- [ ] 8. Test the pipeline

---

## Phase 1: GitHub Repository Setup

### 1.1 Create GitHub Repository

1. Go to https://github.com/ and sign in
2. Click "+" → "New repository"
3. Name: `cicd-assignment`
4. Make it Public or Private
5. Don't initialize with README
6. Click "Create repository"

### 1.2 Push Local Code to GitHub

```bash
cd /home/jake/cicd-assignment

# Initialize git
git init
git add .
git commit -m "Initial commit: Python calculator with unit tests and CI/CD setup"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git

# Push to GitHub
git branch -M main
git push -u origin main
```

✅ **Verify**: Visit your GitHub repository and confirm all files are there.

---

## Phase 2: Jenkins Setup

### 2.1 Start Jenkins with Docker

```bash
cd /home/jake/cicd-assignment

# Start Jenkins
docker-compose up -d

# Wait 30-60 seconds for Jenkins to start
docker logs -f jenkins-cicd
```

Wait until you see: "Jenkins is fully up and running"

### 2.2 Initial Jenkins Configuration

1. **Get initial admin password**:
```bash
docker exec jenkins-cicd cat /var/jenkins_home/secrets/initialAdminPassword
```

2. **Access Jenkins**:
   - Open browser: http://localhost:8080
   - Paste the admin password
   - Click "Install suggested plugins"
   - Wait for installation to complete

3. **Create Admin User**:
   - Username: `admin` (or your choice)
   - Password: Choose a strong password
   - Full name: Your name
   - Email: Your email
   - Click "Save and Continue"

4. **Jenkins URL**:
   - Keep default: http://localhost:8080/
   - Click "Save and Finish"
   - Click "Start using Jenkins"

### 2.3 Install Python in Jenkins Container

```bash
docker exec -it -u root jenkins-cicd bash

# Inside container:
apt-get update
apt-get install -y python3 python3-pip

# Verify
python3 --version
pip3 --version

# Exit
exit
```

### 2.4 Install Additional Jenkins Plugins

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Click **Available** tab
3. Search and install:
   - "GitHub Integration Plugin"
   - "Pipeline"
   - "Git"
   - "Credentials Binding"

4. Check "Restart Jenkins when no jobs are running"

✅ **Verify**: Jenkins restarts successfully and you can log back in.

---

## Phase 3: WebEx Bot Setup

### 3.1 Create WebEx Space

1. Go to https://teams.webex.com/
2. Sign in or create account
3. Click "+" to create new space
4. Name: "Jenkins CI/CD Notifications"
5. Click "Create"

### 3.2 Create Incoming Webhook

**Option A: Via WebEx Teams App (Easiest)**

1. Click on your space name at top
2. Click "Apps"
3. Search "Incoming Webhooks"
4. Click "Add"
5. Name: "Jenkins Build Bot"
6. Copy the Webhook URL
7. Save it somewhere safe!

**Option B: Via Developer Portal**

1. Go to https://developer.webex.com/
2. Sign in
3. Go to "Documentation" → "Webhooks"
4. Follow instructions to create incoming webhook

### 3.3 Test WebEx Webhook

```bash
# Replace with your actual webhook URL
WEBHOOK_URL="https://webexapis.com/v1/webhooks/incoming/YOUR_WEBHOOK_ID_HERE"

# Send test message
curl -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "markdown": "# Test Message\n\nWebEx webhook is working! ✅"
  }'
```

Check your WebEx space - you should see the message!

✅ **Verify**: Test message appears in WebEx space.

### 3.4 Add WebEx Webhook to Jenkins

1. In Jenkins: **Manage Jenkins** → **Manage Credentials**
2. Click "(global)" domain
3. Click "Add Credentials"
4. Fill in:
   - Kind: **Secret text**
   - Scope: **Global**
   - Secret: *[Paste your WebEx Webhook URL]*
   - ID: `webex-webhook-url`
   - Description: `WebEx Webhook URL for notifications`
5. Click "OK"

✅ **Verify**: Credential is saved with ID `webex-webhook-url`.

---

## Phase 4: ngrok Setup

### 4.1 Install ngrok

```bash
cd /home/jake/cicd-assignment

# Download ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar xvzf ngrok-v3-stable-linux-amd64.tgz

# Verify
./ngrok version
```

### 4.2 Sign Up and Configure ngrok

1. Go to https://ngrok.com/
2. Sign up for free account
3. Copy your authtoken from dashboard
4. Configure ngrok:

```bash
./ngrok authtoken YOUR_AUTH_TOKEN_HERE
```

### 4.3 Start ngrok Tunnel

```bash
# Make sure Jenkins is running
docker ps | grep jenkins

# Start ngrok (keep this terminal open!)
./ngrok http 8080
```

### 4.4 Note Your ngrok URL

From ngrok output, copy the HTTPS URL:
```
Forwarding: https://abcd-12-34-56-78.ngrok.io -> http://localhost:8080
```

**Save this URL** - you'll need it for GitHub webhook!

### 4.5 Verify ngrok

1. Open another browser tab: http://127.0.0.1:4040
2. This is ngrok's web interface
3. Visit your ngrok URL (e.g., https://abcd-12-34-56-78.ngrok.io)
4. You should see Jenkins login page

✅ **Verify**: Jenkins is accessible via ngrok URL.

---

## Phase 5: Jenkins Job Configuration

### 5.1 Create Pipeline Job

1. In Jenkins, click "New Item"
2. Name: `cicd-assignment-pipeline`
3. Type: **Pipeline**
4. Click "OK"

### 5.2 Configure Job

**General:**
- Check "GitHub project"
- Project url: `https://github.com/YOUR_USERNAME/cicd-assignment/`

**Build Triggers:**
- Check "GitHub hook trigger for GITScm polling"

**Pipeline:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`

Click **Save**

### 5.3 Test Jenkins Job Manually

1. Click "Build Now"
2. Click on build #1
3. Click "Console Output"
4. Watch the build progress

✅ **Verify**: Build completes successfully and WebEx notification is received.

---

## Phase 6: GitHub Webhook Configuration

### 6.1 Add Webhook to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Webhooks**
3. Click "Add webhook"

4. Configure:
   - Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
     - Example: `https://abcd-12-34-56-78.ngrok.io/github-webhook/`
     - **Important**: Include `/github-webhook/` and trailing slash!
   - Content type: `application/json`
   - Secret: Leave empty
   - Events: "Just the push event"
   - Active: ✓ Checked

5. Click "Add webhook"

### 6.2 Verify Webhook

1. You should see a green checkmark next to the webhook
2. Click on the webhook
3. Scroll to "Recent Deliveries"
4. You should see a "ping" event with 200 response

✅ **Verify**: Webhook shows green checkmark and successful ping delivery.

---

## Phase 7: End-to-End Testing

### 7.1 Prepare for Screen Recording

**Start your screen recording now!**

Make sure you can see:
- Your terminal with ngrok running
- Browser with GitHub repository
- Browser with Jenkins
- WebEx Teams space

### 7.2 Make a Code Change

```bash
cd /home/jake/cicd-assignment

# Make a small change
echo "" >> README.md
echo "## Change Log" >> README.md
echo "- $(date): Pipeline test - everything is working!" >> README.md

# Check the change
git diff README.md
```

### 7.3 Commit and Push

```bash
# Stage the change
git add README.md

# Commit with meaningful message
git commit -m "Test CI/CD pipeline - add changelog entry"

# Push to GitHub
git push origin main
```

### 7.4 Monitor the Pipeline

**GitHub (record this!):**
1. Go to your repository
2. Check the commit timestamp (should show "now")
3. ✅ Shows recent commit with timestamp

**ngrok Inspector (record this!):**
1. Go to http://127.0.0.1:4040
2. You should see incoming POST request from GitHub
3. ✅ Shows webhook event in ngrok

**Jenkins (record this!):**
1. Go to http://localhost:8080
2. Job should trigger automatically
3. Click on the new build
4. Click "Console Output"
5. ✅ Shows build running and completing successfully
6. ✅ Shows all unit tests passing

**WebEx (record this!):**
1. Check your WebEx space
2. You should receive build notification
3. ✅ Shows success notification with build details

---

## Phase 8: Screen Recording Checklist

Your recording should show:

- [ ] Making a code change in terminal
- [ ] Running `git add`, `git commit`, `git push`
- [ ] GitHub repository showing commit with "now" timestamp (5 points)
- [ ] ngrok inspector (http://127.0.0.1:4040) showing incoming webhook (10 points)
- [ ] Jenkins automatically triggering build (10 points)
- [ ] Jenkins console output showing:
  - [ ] All Python unit tests passing
  - [ ] Build completing without errors (10 points)
- [ ] WebEx space receiving build notification (5 points)

**Total: 40 points**

---

## Troubleshooting

### Build not triggering automatically:

1. Check Jenkins job has "GitHub hook trigger" enabled
2. Verify GitHub webhook URL includes `/github-webhook/`
3. Check webhook Recent Deliveries for errors
4. Verify ngrok is running and URL matches webhook
5. Check Jenkins logs: `docker logs -f jenkins-cicd`

### Unit tests failing:

```bash
# Test locally first
cd /home/jake/cicd-assignment
python3 -m unittest test_app.py -v
```

### WebEx notification not received:

1. Test webhook manually:
```bash
WEBHOOK_URL="your-webex-webhook-url"
curl -X POST "$WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "Test"}'
```

2. Check Jenkins credential ID is exactly `webex-webhook-url`
3. Check Jenkinsfile has correct credential reference

### ngrok issues:

- If ngrok URL changed, update GitHub webhook
- Free tier timeout after 8 hours
- Check http://127.0.0.1:4040 for tunnel status

---

## Useful Commands

```bash
# Jenkins
docker-compose up -d                    # Start Jenkins
docker-compose down                     # Stop Jenkins
docker logs -f jenkins-cicd             # View logs
docker exec -it jenkins-cicd bash       # Access container

# ngrok
./ngrok http 8080                       # Start tunnel
curl http://127.0.0.1:4040/api/tunnels  # Get ngrok URL

# Git
git status                              # Check status
git log --oneline -5                    # View recent commits
git push origin main                    # Push changes

# Testing
python3 -m unittest test_app.py -v      # Run tests locally
python3 app.py                          # Run application
```

---

## Summary

You now have a complete CI/CD pipeline:

1. ✅ GitHub repository with Python code and unit tests
2. ✅ Jenkins running in Docker
3. ✅ ngrok exposing Jenkins to internet
4. ✅ GitHub webhook triggering Jenkins builds
5. ✅ WebEx bot sending build notifications

Every time you push code to GitHub:
- GitHub sends webhook → ngrok → Jenkins
- Jenkins runs your tests
- WebEx notifies you of results

Good luck with your assignment! 🚀
