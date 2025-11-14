# START HERE - CI/CD Assignment Setup

## ✅ What's Already Done

Great news! The following is already set up and ready:

1. ✅ **Jenkins Running** on Kubernetes
   - URL: http://jenkins.15.204.74.157.nip.io
   - Password: `8c019e08475445a68a4bc66abf310a69`

2. ✅ **Python 3.13.5 Installed** in Jenkins container

3. ✅ **Code Ready**:
   - [app.py](app.py) - Calculator application
   - [test_app.py](test_app.py) - Unit tests (8 tests, all passing)
   - [Jenkinsfile](Jenkinsfile) - CI/CD pipeline definition

4. ✅ **Helper Scripts Created**:
   - [setup-ngrok.sh](setup-ngrok.sh) - Download and setup ngrok
   - [get-webhook-url.sh](get-webhook-url.sh) - Get GitHub webhook URL

## 🚀 What You Need to Do

Follow these steps in order:

### Step 1: Complete Jenkins Setup (5 minutes)

1. Open http://jenkins.15.204.74.157.nip.io
2. Unlock with password: `8c019e08475445a68a4bc66abf310a69`
3. Install suggested plugins
4. Create your admin user

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-1-complete-jenkins-initial-setup-5-minutes)

---

### Step 2: Create GitHub Repository (10 minutes)

1. Create new repo on GitHub named `cicd-assignment`
2. Push your code:

```bash
cd /home/jake/cicd-assignment
git init
git add .
git commit -m "Initial commit: CI/CD pipeline"
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git
git branch -M main
git push -u origin main
```

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-2-set-up-github-repository-10-minutes)

---

### Step 3: Setup WebEx Bot (10 minutes)

1. Go to https://teams.webex.com/
2. Create space "Jenkins CI/CD Notifications"
3. Add "Incoming Webhooks" app
4. **Save the webhook URL!**

Test it:
```bash
curl -X POST "YOUR_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "✅ Test from Jenkins Setup"}'
```

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-3-set-up-webex-bot-10-minutes)

---

### Step 4: Add WebEx Webhook to Jenkins (5 minutes)

1. Jenkins → Manage Jenkins → Credentials
2. Add Credentials:
   - Kind: **Secret text**
   - Secret: Your WebEx webhook URL
   - ID: `webex-webhook-url` **(MUST be exactly this!)**

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-4-configure-jenkins-credentials-for-webex-5-minutes)

---

### Step 5: Setup ngrok (15 minutes)

```bash
cd /home/jake/cicd-assignment

# Download and setup ngrok
./setup-ngrok.sh

# Add your authtoken (get from https://dashboard.ngrok.com/get-started/your-authtoken)
./ngrok authtoken YOUR_AUTH_TOKEN

# Start ngrok (KEEP THIS TERMINAL OPEN!)
./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite
```

In a **new terminal**:
```bash
cd /home/jake/cicd-assignment
./get-webhook-url.sh
```

Open ngrok web interface: http://127.0.0.1:4040

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-5-set-up-ngrok-15-minutes)

---

### Step 6: Create Jenkins Pipeline Job (10 minutes)

1. Jenkins → New Item
2. Name: `cicd-assignment-pipeline`
3. Type: **Pipeline**
4. Configure:
   - ✓ GitHub project: `https://github.com/YOUR_USERNAME/cicd-assignment`
   - ✓ GitHub hook trigger for GITScm polling
   - Pipeline from SCM → Git
   - Repository: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
5. **Save**
6. **Build Now** to test!

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-6-create-jenkins-pipeline-job-10-minutes)

---

### Step 7: Configure GitHub Webhook (5 minutes)

1. GitHub repo → Settings → Webhooks → Add webhook
2. Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
   - Get URL from `./get-webhook-url.sh`
   - **MUST have /github-webhook/ and trailing slash!**
3. Content type: `application/json`
4. Events: Just the push event
5. Add webhook

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-7-configure-github-webhook-5-minutes)

---

### Step 8: Test & Record Your Demo! (10 minutes)

**Before recording, open these in your browser:**
- GitHub repository
- ngrok web interface (http://127.0.0.1:4040)
- Jenkins dashboard
- WebEx space

**Start recording and run:**
```bash
cd /home/jake/cicd-assignment
echo "# Demo change - $(date)" >> app.py
git add app.py
git commit -m "Demo: Complete CI/CD pipeline"
git push origin main
```

**Show in your recording:**
1. ✅ GitHub commit with "now" timestamp **(5 points)**
2. ✅ ngrok showing incoming webhook **(10 points)**
3. ✅ Jenkins auto-triggering build **(10 points)**
4. ✅ Console output with passing tests **(10 points)**
5. ✅ WebEx notification received **(5 points)**

**Total: 40 points**

**Guide**: See [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#step-8-test-the-complete-cicd-pipeline-5-minutes)

---

## 📚 Documentation Available

| Document | Purpose |
|----------|---------|
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | Quick cheat sheet |
| **[ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md)** | Detailed step-by-step guide |
| [JENKINS_ACCESS.md](JENKINS_ACCESS.md) | Jenkins access info |
| [KUBERNETES_DEPLOYMENT.md](KUBERNETES_DEPLOYMENT.md) | Kubernetes details |
| [README.md](README.md) | Project overview |

## 🛠️ Helper Scripts

```bash
# Setup ngrok
./setup-ngrok.sh

# Get GitHub webhook URL
./get-webhook-url.sh
```

## 🎯 Quick Commands

```bash
# Test your Python code locally
python3 -m unittest test_app.py -v

# Run the application
python3 app.py

# Check Jenkins pod status
kubectl get pods -n cicd-assignment

# View Jenkins logs
kubectl logs -n cicd-assignment deployment/jenkins -f

# Restart Jenkins if needed
kubectl rollout restart deployment/jenkins -n cicd-assignment
```

## ⏱️ Estimated Time

- Jenkins setup: 5 min
- GitHub setup: 10 min
- WebEx setup: 10 min
- Jenkins credentials: 5 min
- ngrok setup: 15 min
- Jenkins pipeline: 10 min
- GitHub webhook: 5 min
- Testing & recording: 10 min

**Total: ~70 minutes**

## 🆘 Need Help?

- **Detailed guide**: [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md)
- **Quick reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Troubleshooting**: See Section in [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md#troubleshooting)

---

## Ready to Start?

1. **Open** [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md)
2. **Follow** each step carefully
3. **Record** your final demo
4. **Submit** your video

**Good luck! You've got this! 🚀**
