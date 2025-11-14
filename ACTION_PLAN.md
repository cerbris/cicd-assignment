# CI/CD Pipeline - Action Plan to Complete Assignment

## Current Status: Infrastructure Ready, Pipeline Not Configured

✅ **What's Working:**
- Jenkins running at http://jenkins.15.204.74.157.nip.io
- Python 3.13.5 installed in Jenkins
- GitHub repository at https://github.com/cerbris/cicd-assignment
- All code files ready (app.py, test_app.py, Jenkinsfile)

❌ **What's NOT Working Yet:**
- Jenkins not configured (needs initial setup)
- No WebEx bot created
- No ngrok tunnel running
- No Jenkins pipeline job created
- No GitHub webhook configured
- **The automated CI/CD flow doesn't work yet**

---

## STEP-BY-STEP ACTION PLAN

### ⚡ STEP 1: Complete Jenkins Initial Setup (5 minutes)

**DO THIS NOW:**

1. **Open Jenkins**: http://jenkins.15.204.74.157.nip.io
2. **Unlock Jenkins**:
   - Password: `8c019e08475445a68a4bc66abf310a69`
   - Paste it and click "Continue"
3. **Install Plugins**:
   - Click **"Install suggested plugins"**
   - Wait 3-5 minutes for plugins to install
4. **Create Admin User**:
   - Username: (your choice)
   - Password: (your choice)
   - Full name: (your name)
   - Email: (your email)
   - Click "Save and Continue"
5. **Jenkins URL**:
   - Keep default: `http://jenkins.15.204.74.157.nip.io/`
   - Click "Save and Finish"
6. **Start Using Jenkins**

**Verify**: You should see the Jenkins dashboard

---

### ⚡ STEP 2: Create WebEx Bot (10 minutes)

**DO THIS NOW:**

1. **Go to WebEx**: https://teams.webex.com/
2. **Sign in** with your Webex account
3. **Create Space**:
   - Click "+" or "Create a space"
   - Name: `Jenkins CI/CD Notifications`
   - Click "Create"
4. **Add Incoming Webhook**:
   - In the space, click the **space name** at the top
   - Click "Apps" tab
   - Search for: `Incoming Webhooks`
   - Click "Add"
   - Webhook Name: `Jenkins Build Bot`
   - Click "Add"
5. **COPY THE WEBHOOK URL** (VERY IMPORTANT!)
   - Example: `https://webexapis.com/v1/webhooks/incoming/Y2lzY29...`
   - Save it somewhere safe!

**Test it immediately**:
```bash
# Replace YOUR_WEBHOOK_URL with actual URL
curl -X POST "YOUR_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "✅ **WebEx Integration Test**\n\nIf you see this, WebEx is working!"}'
```

**Verify**: You should see a test message in your WebEx space

---

### ⚡ STEP 3: Add WebEx Webhook to Jenkins (3 minutes)

**DO THIS NOW:**

1. **In Jenkins**: Click "Manage Jenkins" (left sidebar)
2. Click "Credentials"
3. Click "System" → "(global)" domain
4. Click "Add Credentials" (left sidebar)
5. **Configure**:
   - Kind: **Secret text**
   - Scope: **Global**
   - Secret: **Paste your WebEx webhook URL**
   - ID: `webex-webhook-url` ← **MUST BE EXACTLY THIS!**
   - Description: `WebEx Webhook for Build Notifications`
6. Click **"Create"**

**Verify**: You should see the credential listed with ID `webex-webhook-url`

---

### ⚡ STEP 4: Setup ngrok (10 minutes)

**DO THIS NOW:**

```bash
cd /home/jake/cicd-assignment

# Run setup script
./setup-ngrok.sh
```

**Get ngrok auth token**:
1. Go to https://ngrok.com/ and sign up/login
2. Go to Dashboard → "Your Authtoken"
3. Copy the token

**Configure ngrok**:
```bash
# Replace YOUR_TOKEN with actual token
./ngrok authtoken YOUR_TOKEN
```

**Start ngrok** (OPEN A NEW TERMINAL - KEEP IT RUNNING):
```bash
cd /home/jake/cicd-assignment

# This terminal must stay open!
./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite
```

You'll see output like:
```
Forwarding   https://xxxx-yyyy.ngrok-free.app -> http://jenkins.15.204.74.157.nip.io
```

**Get your webhook URL** (in a DIFFERENT terminal):
```bash
cd /home/jake/cicd-assignment
./get-webhook-url.sh
```

**Open ngrok web interface**: http://127.0.0.1:4040
- **KEEP THIS OPEN** - you'll need it for recording!

**Verify**: ngrok dashboard shows "online" status

---

### ⚡ STEP 5: Create Jenkins Pipeline Job (10 minutes)

**DO THIS NOW:**

1. **In Jenkins dashboard**: Click "New Item"
2. **Job configuration**:
   - Item name: `cicd-assignment-pipeline`
   - Type: **Pipeline**
   - Click "OK"

3. **Configure the job**:

   **General Section:**
   - ✅ Check "GitHub project"
   - Project URL: `https://github.com/cerbris/cicd-assignment`

   **Build Triggers:**
   - ✅ Check "GitHub hook trigger for GITScm polling"

   **Pipeline:**
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/cerbris/cicd-assignment.git`
   - Credentials: **(none)** - leave blank for public repo
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile`

4. Click **"Save"**

**Test the pipeline manually**:
1. Click "Build Now"
2. Click build #1 → "Console Output"
3. **Watch it run**:
   - ✅ Should checkout code
   - ✅ Should show Python version
   - ✅ Should run 8 unit tests
   - ✅ Should pass all tests
   - ✅ Should send WebEx notification

**Verify**: Build succeeds AND you get a WebEx message!

---

### ⚡ STEP 6: Configure GitHub Webhook (5 minutes)

**DO THIS NOW:**

1. **Get your ngrok webhook URL**:
   ```bash
   cd /home/jake/cicd-assignment
   ./get-webhook-url.sh
   ```

   Example output: `https://a1b2-c3d4.ngrok-free.app/github-webhook/`

2. **Go to GitHub**: https://github.com/cerbris/cicd-assignment
3. Click **Settings** → **Webhooks** → **Add webhook**
4. **Configure**:
   - Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
     - **MUST include /github-webhook/ and trailing slash!**
   - Content type: `application/json`
   - Which events: **Just the push event**
   - Active: ✅ Checked
5. Click **"Add webhook"**

**Verify**: After a few seconds, you should see a green ✅ checkmark next to the webhook

---

### ⚡ STEP 7: TEST THE COMPLETE PIPELINE! (5 minutes)

**DO THIS NOW:**

```bash
cd /home/jake/cicd-assignment

# Make a test change
echo "# Test change - $(date)" >> app.py

# Commit and push
git add app.py
git commit -m "Test: Verify CI/CD pipeline is working"
git push origin main
```

**Watch what happens**:
1. ✅ GitHub receives the push
2. ✅ GitHub sends webhook to ngrok
3. ✅ ngrok forwards to Jenkins
4. ✅ Jenkins automatically triggers build
5. ✅ Tests run and pass
6. ✅ WebEx receives notification

**Check these places**:
- **GitHub**: Commit shows "now" timestamp
- **ngrok** (http://127.0.0.1:4040): Shows webhook POST request
- **Jenkins**: Build #2 starts automatically
- **Jenkins Console**: Tests pass
- **WebEx**: Success notification appears

**If it works - YOU'RE READY TO RECORD!**

---

### 🎬 STEP 8: RECORD YOUR DEMO (10 minutes)

**Arrange your screen to show**:
- Terminal window (for git commands)
- Browser with tabs:
  - GitHub repository
  - ngrok web interface (http://127.0.0.1:4040)
  - Jenkins dashboard
  - WebEx space

**Start recording and do this**:

```bash
cd /home/jake/cicd-assignment

# Make another change
echo "# Final demo - $(date)" >> app.py

git add app.py
git commit -m "Final demo: Complete CI/CD pipeline"
git push origin main
```

**Show in your recording (in this order)**:

1. **Terminal**: Git commands pushing code **(background)**

2. **GitHub**: Navigate to commits
   - Show the commit you just made
   - **Highlight timestamp showing "now"** ← **(5 points)**

3. **ngrok**: Switch to http://127.0.0.1:4040
   - Show the POST request to `/github-webhook/`
   - Show request details **(10 points)**

4. **Jenkins**: Dashboard
   - Show build starting automatically
   - Show "Started by GitHub push" **(10 points)**

5. **Jenkins Console**: Click build → Console Output
   - Show all 8 tests running
   - Show all tests passing
   - Show "BUILD SUCCESS" **(10 points)**

6. **WebEx**: Show the notification
   - Shows build number, status, timestamp **(5 points)**

**Total: 40 points**

---

## ⚠️ TROUBLESHOOTING

### Jenkins won't build
- Check webhook has green checkmark on GitHub
- Verify ngrok is running (check http://127.0.0.1:4040)
- Check Jenkins job has "GitHub hook trigger" enabled

### Tests fail
```bash
# Test locally first
cd /home/jake/cicd-assignment
python3 -m unittest test_app.py -v
```

### WebEx not working
- Verify credential ID is exactly `webex-webhook-url`
- Test webhook manually with curl
- Check Jenkins console for curl errors

### ngrok URL changed
- Free tier changes URL on restart
- Update GitHub webhook with new URL from `./get-webhook-url.sh`

---

## 📋 QUICK CHECKLIST

Before recording, verify:
- [ ] Jenkins is configured and working
- [ ] WebEx webhook tested and working
- [ ] ngrok running (terminal open)
- [ ] ngrok web interface open (http://127.0.0.1:4040)
- [ ] Jenkins pipeline job created
- [ ] Manual build succeeded
- [ ] WebEx credential added to Jenkins
- [ ] GitHub webhook configured
- [ ] Test commit triggered build automatically
- [ ] All 8 tests pass
- [ ] WebEx notification received

**When all checked - START RECORDING!**

---

## 🎯 Your Goal

Show a working end-to-end CI/CD pipeline:

**Code Push** → **GitHub** → **Webhook** → **ngrok** → **Jenkins** → **Tests** → **WebEx**

Follow the steps above in order. Don't skip any! Good luck! 🚀
