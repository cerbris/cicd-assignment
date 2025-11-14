# Quick Start Guide - CI/CD Assignment

This is the fastest way to get your CI/CD pipeline running!

## 📋 Prerequisites

Install these first:
```bash
# Check Docker
docker --version

# If not installed (Arch Linux):
sudo pacman -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

## 🚀 Quick Setup (5 Steps)

### Step 1: Push Code to GitHub (5 minutes)

1. Create repository on GitHub: https://github.com/new
   - Name: `cicd-assignment`
   - Don't initialize with README

2. Push code:
```bash
cd /home/jake/cicd-assignment

git init
git add .
git commit -m "Initial commit: CI/CD pipeline setup"
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git
git branch -M main
git push -u origin main
```

✅ Verify: Code appears on GitHub

---

### Step 2: Start Jenkins (5 minutes)

```bash
cd /home/jake/cicd-assignment
./scripts/start-jenkins.sh
```

This will:
- Start Jenkins in Docker
- Show you the admin password
- Open http://localhost:8080

Setup Jenkins:
1. Paste admin password
2. Click "Install suggested plugins"
3. Create admin user
4. Click "Save and Continue" → "Start using Jenkins"

Install Python in Jenkins:
```bash
docker exec -it -u root jenkins-cicd bash
apt-get update && apt-get install -y python3 python3-pip
python3 --version
exit
```

✅ Verify: Jenkins is running at http://localhost:8080

---

### Step 3: Setup WebEx (5 minutes)

1. Go to https://teams.webex.com/
2. Create space: "Jenkins CI/CD Notifications"
3. Click space name → Apps → "Incoming Webhooks" → Add
4. Name: "Jenkins Build Bot"
5. **Copy the Webhook URL!**

Test it:
```bash
cd /home/jake/cicd-assignment
./scripts/test-webex.sh
# Paste your webhook URL when prompted
```

Add to Jenkins:
1. Jenkins → Manage Jenkins → Manage Credentials
2. Add Credentials:
   - Kind: Secret text
   - Secret: [Paste webhook URL]
   - ID: `webex-webhook-url`
   - Click OK

✅ Verify: Test message appears in WebEx space

---

### Step 4: Start ngrok (5 minutes)

1. Sign up: https://ngrok.com/
2. Get authtoken from dashboard
3. Configure and start:

```bash
cd /home/jake/cicd-assignment

# Configure (first time only)
./ngrok authtoken YOUR_AUTH_TOKEN

# Start ngrok (keep terminal open!)
./scripts/start-ngrok.sh
```

Get your ngrok URL (in new terminal):
```bash
cd /home/jake/cicd-assignment
./scripts/get-ngrok-url.sh
```

**Copy the GitHub Webhook URL** shown!

✅ Verify: Can access Jenkins via ngrok URL

---

### Step 5: Configure Everything (10 minutes)

**A. Create Jenkins Job**

1. Jenkins → New Item
2. Name: `cicd-assignment-pipeline`
3. Type: Pipeline → OK
4. Configure:
   - **GitHub project**: ✓
   - Project URL: `https://github.com/YOUR_USERNAME/cicd-assignment`
   - **Build Triggers**: ✓ GitHub hook trigger for GITScm polling
   - **Pipeline**:
     - Definition: Pipeline script from SCM
     - SCM: Git
     - Repository: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
     - Branch: `*/main`
     - Script Path: `Jenkinsfile`
5. Save

**B. Test Build Manually**

1. Click "Build Now"
2. Click build #1 → Console Output
3. Wait for success ✅

**C. Add GitHub Webhook**

1. GitHub repository → Settings → Webhooks → Add webhook
2. Fill in:
   - Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
     - (Use URL from `get-ngrok-url.sh`)
     - **Must include /github-webhook/ and trailing slash!**
   - Content type: `application/json`
   - Events: Just the push event
   - Active: ✓
3. Add webhook

✅ Verify: Green checkmark appears next to webhook

---

## 🎬 Recording Your Demo

Now you're ready to record! Make sure you can see:
- Terminal
- GitHub repository
- http://127.0.0.1:4040 (ngrok inspector)
- http://localhost:8080 (Jenkins)
- WebEx space

**Start recording and run:**
```bash
cd /home/jake/cicd-assignment
./scripts/test-pipeline.sh
```

This will:
1. Create a test commit
2. Push to GitHub
3. Trigger the webhook
4. Run Jenkins build
5. Send WebEx notification

**Show in your recording:**
- [x] Git commands pushing code (terminal)
- [x] GitHub commit with "now" timestamp (5 pts)
- [x] ngrok showing webhook request (10 pts)
- [x] Jenkins auto-triggering build (10 pts)
- [x] Console output with passing tests (10 pts)
- [x] WebEx notification received (5 pts)

Total: 40 points

---

## 🔧 Troubleshooting

### Build not triggering?
- Check webhook URL has `/github-webhook/` and trailing slash
- Verify Jenkins job has "GitHub hook trigger" enabled
- Check GitHub webhook "Recent Deliveries" for errors

### Tests failing locally?
```bash
cd /home/jake/cicd-assignment
python3 -m unittest test_app.py -v
```

### WebEx not working?
```bash
./scripts/test-webex.sh
```
Verify credential ID in Jenkins is exactly `webex-webhook-url`

### ngrok URL changed?
Free tier changes URL on restart. Get new URL:
```bash
./scripts/get-ngrok-url.sh
```
Update GitHub webhook with new URL.

---

## 📁 Project Structure

```
cicd-assignment/
├── app.py                      # Python calculator app
├── test_app.py                 # Unit tests
├── Jenkinsfile                 # Pipeline definition
├── requirements.txt            # Python dependencies
├── docker-compose.yml          # Jenkins Docker config
├── SETUP_GUIDE.md             # Detailed guide
├── QUICK_START.md             # This file
├── README.md                   # Project overview
├── scripts/
│   ├── start-jenkins.sh       # Start Jenkins
│   ├── start-ngrok.sh         # Start ngrok
│   ├── get-ngrok-url.sh       # Get ngrok URL
│   ├── test-webex.sh          # Test WebEx webhook
│   └── test-pipeline.sh       # Make test commit
└── setup/
    ├── github-setup.md        # GitHub details
    ├── jenkins-setup.md       # Jenkins details
    ├── ngrok-setup.md         # ngrok details
    └── webex-setup.md         # WebEx details
```

---

## 📚 Resources

- Full Guide: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- Detailed Docs: [setup/](setup/) directory
- Jenkins Docs: https://www.jenkins.io/doc/
- ngrok Docs: https://ngrok.com/docs
- WebEx Docs: https://developer.webex.com/

---

## 🎯 Final Checklist

Before recording:
- [ ] GitHub repository created and code pushed
- [ ] Jenkins running and configured
- [ ] WebEx webhook working (test message received)
- [ ] ngrok tunnel running
- [ ] Jenkins job created and tested manually
- [ ] GitHub webhook configured
- [ ] Test commit triggers build successfully

During recording:
- [ ] Show git commit in terminal
- [ ] Show GitHub with "now" timestamp
- [ ] Show ngrok inspector with webhook
- [ ] Show Jenkins build auto-triggering
- [ ] Show console output with passing tests
- [ ] Show WebEx notification

Good luck! 🚀
