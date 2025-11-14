# Next Steps - Complete Your CI/CD Assignment

## ✅ What's Complete (37.5%)

Great progress! You've completed:

1. ✅ **Jenkins Running** - http://jenkins.15.204.74.157.nip.io
2. ✅ **Python Installed** - Python 3.13.5 in Jenkins
3. ✅ **GitHub Repository** - https://github.com/cerbris/cicd-assignment

**Jenkins Password**: `8c019e08475445a68a4bc66abf310a69`

---

## 🎯 Remaining Steps (62.5%)

### STEP 1: Complete Jenkins Initial Setup (5 minutes) ⏳

1. Open http://jenkins.15.204.74.157.nip.io
2. Enter password: `8c019e08475445a68a4bc66abf310a69`
3. Click **"Install suggested plugins"** (wait 3-5 minutes)
4. Create admin user (fill in your details)
5. Accept default Jenkins URL
6. Click **"Start using Jenkins"**

**Status**: Jenkins is running, just needs initial configuration!

---

### STEP 2: Set Up WebEx Bot (10 minutes) ⏳

#### Create WebEx Space

1. Go to https://teams.webex.com/
2. Sign in with your WebEx account
3. Click **"Create a space"**
4. Name: `Jenkins CI/CD Notifications`
5. Click **"Create"**

#### Add Incoming Webhook

1. In your space, click the **space name** at the top
2. Click **"Apps"** tab
3. Search for: `Incoming Webhooks`
4. Click **"Add"**
5. Webhook Name: `Jenkins Build Bot`
6. Click **"Add"**
7. **COPY THE WEBHOOK URL** - You'll need this!

Example URL:
```
https://webexapis.com/v1/webhooks/incoming/Y2lzY29zcGFyazovL3VzL1dFQkhPT0svYWJjZGVm...
```

#### Test the Webhook

```bash
# Replace YOUR_WEBHOOK_URL with the URL you copied
curl -X POST "YOUR_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "✅ **Test Message from Jenkins Setup**\n\nWebEx integration is working!"}'
```

You should see a message appear in your WebEx space!

---

### STEP 3: Add WebEx Webhook to Jenkins (5 minutes) ⏳

1. In Jenkins, go to **Manage Jenkins** (left sidebar)
2. Click **Credentials**
3. Click **System** → **(global)** domain
4. Click **Add Credentials** (left sidebar)
5. Configure:
   - **Kind**: Secret text
   - **Scope**: Global
   - **Secret**: Paste your WebEx webhook URL
   - **ID**: `webex-webhook-url` ← **MUST be exactly this!**
   - **Description**: `WebEx Webhook for Build Notifications`
6. Click **Create**

**Verify**: The credential should appear in the list with ID `webex-webhook-url`

---

### STEP 4: Set Up ngrok (15 minutes) ⏳

#### Download and Configure ngrok

```bash
cd /home/jake/cicd-assignment

# Run the setup script
./setup-ngrok.sh
```

#### Get Your ngrok Auth Token

1. Go to https://ngrok.com/ and sign up/login
2. Go to **Dashboard** → **Your Authtoken**
3. Copy your authtoken

#### Configure ngrok

```bash
# Replace YOUR_AUTH_TOKEN with your actual token
./ngrok authtoken YOUR_AUTH_TOKEN
```

#### Start ngrok Tunnel

**Important**: Open a NEW terminal and keep it running!

```bash
cd /home/jake/cicd-assignment

# Start ngrok tunnel (KEEP THIS TERMINAL OPEN!)
./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite
```

You should see:
```
Session Status                online
Forwarding                    https://xxxx-yyyy.ngrok-free.app -> http://jenkins.15.204.74.157.nip.io
```

#### Get Your Webhook URL

In a **different terminal**:

```bash
cd /home/jake/cicd-assignment
./get-webhook-url.sh
```

This will show you the URL to use for GitHub webhook.

#### Access ngrok Web Interface

Open http://127.0.0.1:4040 in your browser.

**Keep this open!** You'll need to show this in your recording.

---

### STEP 5: Create Jenkins Pipeline Job (10 minutes) ⏳

1. In Jenkins, click **New Item** (left sidebar)
2. Enter item name: `cicd-assignment-pipeline`
3. Select **Pipeline**
4. Click **OK**

#### Configure the Pipeline:

**General Section:**
- ✅ Check **GitHub project**
- Project URL: `https://github.com/cerbris/cicd-assignment`

**Build Triggers:**
- ✅ Check **GitHub hook trigger for GITScm polling**

**Pipeline Section:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/cerbris/cicd-assignment.git`
- Credentials: (leave as "none" for public repo)
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`

**Click Save!**

#### Test the Pipeline

1. Click **Build Now** (left sidebar)
2. Click the build number (e.g., #1)
3. Click **Console Output**
4. Watch the build run - it should:
   - ✅ Checkout code from GitHub
   - ✅ Show Python version
   - ✅ Run all 8 unit tests successfully
   - ✅ Run the application
   - ✅ Send WebEx notification

**If the build succeeds, you should get a WebEx notification!**

---

### STEP 6: Configure GitHub Webhook (5 minutes) ⏳

1. Go to https://github.com/cerbris/cicd-assignment
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure:
   - **Payload URL**: Get from `./get-webhook-url.sh`
     - Format: `https://YOUR-NGROK-URL/github-webhook/`
     - Example: `https://a1b2-c3d4.ngrok-free.app/github-webhook/`
     - **MUST have /github-webhook/ and trailing slash!**
   - **Content type**: `application/json`
   - **Which events**: Just the push event ✅
   - **Active**: ✅ Checked
4. Click **Add webhook**

**Verify**: After a few seconds, you should see a green checkmark ✅ next to the webhook.

---

### STEP 7: Test & Record Your Demo! (10 minutes) 🎬

#### Before Recording - Setup Your Screen

Open these in your browser/terminals:
- Terminal window (for git commands)
- GitHub repository page
- ngrok web interface: http://127.0.0.1:4040
- Jenkins dashboard
- WebEx space

#### Start Recording and Run Test

```bash
cd /home/jake/cicd-assignment

# Make a change
echo "# Demo change - $(date)" >> app.py

# Commit and push
git add app.py
git commit -m "Demo: Complete CI/CD pipeline test"
git push origin main
```

#### Show These in Your Recording (40 points total):

1. ✅ **GitHub Commit** - Show timestamp as "now" **(5 points)**
   - Navigate to GitHub repository
   - Show the commit you just made
   - Highlight the timestamp showing "now" or "seconds ago"

2. ✅ **ngrok Webhook** - Show incoming request **(10 points)**
   - Switch to http://127.0.0.1:4040
   - Show the POST request from GitHub to `/github-webhook/`

3. ✅ **Jenkins Auto-Trigger** - Build starts automatically **(10 points)**
   - Switch to Jenkins dashboard
   - Show build #2 (or next number) starting automatically
   - Show it was triggered by GitHub push

4. ✅ **Console Output** - All tests passing **(10 points)**
   - Click on the build number
   - Click "Console Output"
   - Show all 8 unit tests running and passing
   - Show "BUILD SUCCESS" or "Finished: SUCCESS"

5. ✅ **WebEx Notification** - Message received **(5 points)**
   - Switch to WebEx space
   - Show the success notification from Jenkins
   - Message should show build number, status, and timestamp

---

## 📊 Progress Tracker

- [x] Jenkins running in Kubernetes
- [x] Python installed in Jenkins
- [x] GitHub repository created with code
- [ ] Jenkins initial setup completed
- [ ] WebEx bot created and tested
- [ ] WebEx webhook added to Jenkins credentials
- [ ] ngrok installed and running
- [ ] Jenkins pipeline job created and tested
- [ ] GitHub webhook configured
- [ ] Complete pipeline tested and recorded

**Current Progress: 37.5% → Target: 100%**

---

## 🔗 Quick Links

| Resource | URL |
|----------|-----|
| Jenkins | http://jenkins.15.204.74.157.nip.io |
| GitHub Repo | https://github.com/cerbris/cicd-assignment |
| WebEx | https://teams.webex.com/ |
| ngrok Web UI | http://127.0.0.1:4040 (after ngrok starts) |
| ngrok Dashboard | https://dashboard.ngrok.com/ |

**Jenkins Password**: `8c019e08475445a68a4bc66abf310a69`

---

## 🛠️ Helper Commands

```bash
# Get ngrok webhook URL for GitHub
./get-webhook-url.sh

# Test Python code locally
python3 -m unittest test_app.py -v

# Check Jenkins pod
kubectl get pods -n cicd-assignment

# View Jenkins logs
kubectl logs -n cicd-assignment deployment/jenkins -f

# Restart Jenkins if needed
kubectl rollout restart deployment/jenkins -n cicd-assignment
```

---

## 📚 Documentation

- **[START_HERE.md](START_HERE.md)** - Main starting guide
- **[ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md)** - Detailed walkthrough
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference
- **[CREATE_GITHUB_REPO.md](CREATE_GITHUB_REPO.md)** - GitHub setup (complete!)

---

## ⏱️ Time Estimate for Remaining Steps

- Jenkins setup: 5 min
- WebEx setup: 10 min
- Jenkins credentials: 5 min
- ngrok setup: 15 min
- Jenkins pipeline: 10 min
- GitHub webhook: 5 min
- Testing & recording: 10 min

**Total: ~60 minutes to completion!**

---

## 🎯 Your Assignment Goal

**Total Points: 40**

Create a screen recording showing the complete CI/CD pipeline in action:
- Code commit → GitHub → Webhook → ngrok → Jenkins → Tests → WebEx

You're 37.5% done! Follow the steps above to complete your assignment. Good luck! 🚀
