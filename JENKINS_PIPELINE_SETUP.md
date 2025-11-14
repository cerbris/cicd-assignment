# Jenkins Pipeline Setup Guide

## Overview

The Jenkinsfile is already in your repository at: [Jenkinsfile](Jenkinsfile)

This guide shows you how to configure Jenkins to use it.

---

## What the Pipeline Does

```
┌─────────────┐
│  Stage 1:   │ → Checkout code from GitHub
│  Checkout   │
└─────────────┘
       ↓
┌─────────────┐
│  Stage 2:   │ → Verify Python & pip installed
│  Setup Env  │
└─────────────┘
       ↓
┌─────────────┐
│  Stage 3:   │ → Run 8 unit tests
│  Run Tests  │ → All must pass
└─────────────┘
       ↓
┌─────────────┐
│  Stage 4:   │ → Execute calculator app
│  Run App    │
└─────────────┘
       ↓
┌─────────────┐
│   Success   │ → Send ✅ notification to WebEx
│  or Failure │ → Send ❌ notification to WebEx
└─────────────┘
```

---

## Step 1: Create Jenkins Pipeline Job

### 1.1 Access Jenkins

Go to: http://jenkins.15.204.74.157.nip.io

(If not logged in, use the admin credentials you created)

### 1.2 Create New Item

1. Click **"New Item"** (left sidebar)
2. Enter name: `cicd-assignment-pipeline`
3. Select **"Pipeline"**
4. Click **"OK"**

---

## Step 2: Configure the Pipeline Job

You'll see a configuration page. Fill it out as follows:

### General Section

✅ **Check**: "GitHub project"
- Project URL: `https://github.com/cerbris/cicd-assignment`

**Description** (optional):
```
CI/CD Pipeline for Python Calculator Application
- Automated testing on every commit
- WebEx notifications for build status
```

### Build Triggers

✅ **Check**: "GitHub hook trigger for GITScm polling"

This allows GitHub webhooks to trigger builds automatically.

### Pipeline Section

**Definition**: Select **"Pipeline script from SCM"**

**SCM**: Select **"Git"**

**Repository Configuration**:
- Repository URL: `https://github.com/cerbris/cicd-assignment.git`
- Credentials: **(none)** - leave blank for public repositories
- Branch Specifier: `*/main`

**Script Path**: `Jenkinsfile`

**Lightweight checkout**: ✅ Check this (optional, makes checkout faster)

### Click "Save"

---

## Step 3: Test the Pipeline Manually

Before setting up the webhook, test that the pipeline works:

1. Go to your pipeline: `cicd-assignment-pipeline`
2. Click **"Build Now"** (left sidebar)
3. Click the build number (e.g., **#1**)
4. Click **"Console Output"**

### Expected Output:

```
Started by user admin
...
Checking out code from GitHub...
...
Setting up Python environment...
Python 3.13.5
pip 25.1.1
...
Running unit tests...
test_add (test_app.TestCalculator.test_add) ... ok
test_divide (test_app.TestCalculator.test_divide) ... ok
test_divide_by_zero (test_app.TestCalculator.test_divide_by_zero) ... ok
test_modulo (test_app.TestCalculator.test_modulo) ... ok
test_modulo_by_zero (test_app.TestCalculator.test_modulo_by_zero) ... ok
test_multiply (test_app.TestCalculator.test_multiply) ... ok
test_power (test_app.TestCalculator.test_power) ... ok
test_subtract (test_app.TestCalculator.test_subtract) ... ok
...
Ran 8 tests in 0.001s
OK
...
Running the application...
Calculator Demo
========================================
5 + 3 = 8
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
17 % 5 = 2
========================================
...
Build succeeded! Sending notification to WebEx...
...
Finished: SUCCESS
```

### ✅ Success Indicators:

- All 8 tests pass
- Build shows "SUCCESS"
- You receive a WebEx notification (if WebEx credential is configured)

---

## Step 4: Understanding the Jenkinsfile

Your [Jenkinsfile](Jenkinsfile) has these key components:

### Environment Variables

```groovy
environment {
    WEBEX_WEBHOOK_URL = credentials('webex-webhook-url')
}
```

This loads your WebEx webhook URL from Jenkins credentials.

**IMPORTANT**: The credential ID **must be exactly** `webex-webhook-url`

### Stages

1. **Checkout**: Gets code from GitHub
2. **Setup Python Environment**: Verifies Python is installed
3. **Run Unit Tests**: Executes all 8 tests
4. **Run Application**: Runs the calculator demo

### Post Actions

```groovy
post {
    success { ... }  // Sends ✅ to WebEx
    failure { ... }  // Sends ❌ to WebEx
    always { ... }   // Runs regardless
}
```

### WebEx Notification Function

```groovy
def sendWebExNotification(String status) {
    // Formats and sends message to WebEx
}
```

Sends a formatted notification with:
- Build status (SUCCESS/FAILURE)
- Job name
- Build number
- Git branch and commit
- Build URL
- Timestamp

---

## Step 5: Verify Configuration

### Check 1: Job Configuration

Go to your pipeline → **Configure** and verify:

- [x] GitHub project URL is correct
- [x] GitHub hook trigger is enabled
- [x] Pipeline definition is "Pipeline script from SCM"
- [x] Repository URL is correct
- [x] Branch is `*/main`
- [x] Script path is `Jenkinsfile`

### Check 2: WebEx Credential

Go to **Manage Jenkins** → **Credentials** → **System** → **(global)**

Verify:
- [x] Credential exists with ID: `webex-webhook-url`
- [x] Type is "Secret text"
- [x] Secret contains your WebEx webhook URL

### Check 3: Manual Build

- [x] Manual build succeeds
- [x] All 8 tests pass
- [x] WebEx notification is received

---

## Step 6: Enable Automatic Builds (GitHub Webhook)

Now that manual builds work, configure GitHub to trigger builds automatically.

See: [ACTION_PLAN.md](ACTION_PLAN.md) Step 6 for detailed instructions.

**Quick version:**

1. Get ngrok webhook URL: `./get-webhook-url.sh`
2. Go to GitHub repo → Settings → Webhooks → Add webhook
3. Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
4. Content type: `application/json`
5. Events: Just the push event
6. Add webhook

---

## Step 7: Test Automatic Build

Make a commit:

```bash
cd /home/jake/cicd-assignment

echo "# Test automatic build - $(date)" >> app.py
git add app.py
git commit -m "Test: Verify automatic build trigger"
git push origin main
```

**Watch these places:**

1. **ngrok** (http://127.0.0.1:4040): Shows incoming webhook
2. **Jenkins**: Build #2 starts automatically
3. **Console**: Shows "Started by GitHub push"
4. **WebEx**: Receives notification

---

## Troubleshooting

### Build fails: "python3: command not found"

Python isn't installed in Jenkins container.

**Fix:**
```bash
# Get pod name
kubectl get pods -n cicd-assignment

# Install Python
kubectl exec -n cicd-assignment POD_NAME -- bash -c \
  "apt-get update && apt-get install -y python3 python3-pip curl"
```

### Build fails: "webex-webhook-url: credentials not found"

The WebEx credential isn't configured or has wrong ID.

**Fix:**
1. Go to Manage Jenkins → Credentials
2. Verify credential ID is **exactly** `webex-webhook-url` (no typos!)

### Tests fail

Test locally first:

```bash
cd /home/jake/cicd-assignment
python3 -m unittest test_app.py -v
```

If they pass locally but fail in Jenkins, check Python version compatibility.

### WebEx notification not sent

Check Jenkins console output for curl errors:

```bash
# Look for lines like:
curl -X POST https://webexapis.com/v1/webhooks/incoming/...
```

Test the webhook manually:

```bash
curl -X POST "YOUR_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "Test from terminal"}'
```

### Build doesn't trigger automatically

1. **Check GitHub webhook**:
   - Go to repo → Settings → Webhooks
   - Should have green ✅ checkmark
   - Click webhook → "Recent Deliveries"
   - Check for errors

2. **Check ngrok**:
   - Is ngrok running?
   - Check http://127.0.0.1:4040 for requests

3. **Check Jenkins job**:
   - Is "GitHub hook trigger" enabled?

---

## Pipeline Configuration Summary

```yaml
Job Name: cicd-assignment-pipeline
Type: Pipeline
Triggers: GitHub hook
Source: Git SCM
Repository: https://github.com/cerbris/cicd-assignment.git
Branch: */main
Script: Jenkinsfile

Prerequisites:
  - Python 3 installed in Jenkins
  - WebEx credential configured (ID: webex-webhook-url)
  - GitHub repository accessible
  - ngrok tunnel running (for webhooks)
```

---

## Next Steps

Once your pipeline is configured and tested:

1. ✅ Manual build succeeds
2. ✅ WebEx notifications work
3. ✅ GitHub webhook configured
4. ✅ Automatic builds work

**You're ready to record your demo!**

See [ACTION_PLAN.md](ACTION_PLAN.md) Step 8 for recording instructions.

---

## Quick Reference

**Jenkins URL**: http://jenkins.15.204.74.157.nip.io
**Pipeline Job**: cicd-assignment-pipeline
**GitHub Repo**: https://github.com/cerbris/cicd-assignment
**Jenkinsfile**: In repository root

**Test Commands**:
```bash
# Test Python code locally
python3 -m unittest test_app.py -v

# Make test commit
echo "# Test" >> app.py && git add . && git commit -m "Test" && git push

# Get ngrok URL
./get-webhook-url.sh

# View Jenkins logs
kubectl logs -n cicd-assignment deployment/jenkins -f
```

Good luck! 🚀
