# CI/CD Assignment - Complete Setup Guide

## Current Status
✅ Jenkins is running at: http://jenkins.15.204.74.157.nip.io
✅ Initial password: `8c019e08475445a68a4bc66abf310a69`
✅ Python 3.13.5 installed in Jenkins container

## Step-by-Step Setup Guide

---

### STEP 1: Complete Jenkins Initial Setup (5 minutes)

1. **Access Jenkins**: http://jenkins.15.204.74.157.nip.io
2. **Unlock Jenkins**: Enter password `8c019e08475445a68a4bc66abf310a69`
3. **Install Plugins**: Click "Install suggested plugins" and wait
4. **Create Admin User**: Fill in your details (save credentials!)
5. **Instance Configuration**: Accept the default URL
6. **Start Using Jenkins**: Click "Start using Jenkins"

---

### STEP 2: Set Up GitHub Repository (10 minutes)

#### 2.1 Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `cicd-assignment`
3. Description: "CI/CD Pipeline Demo"
4. Public repository (easier for webhooks)
5. **Do NOT initialize** with README, .gitignore, or license
6. Click "Create repository"

#### 2.2 Push Your Code to GitHub

```bash
cd /home/jake/cicd-assignment

# Initialize git if not already done
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CI/CD pipeline with Jenkins and WebEx"

# Add your GitHub repository as remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Verify**: Check that all files appear on GitHub

---

### STEP 3: Set Up WebEx Bot (10 minutes)

#### 3.1 Create WebEx Space

1. Go to https://teams.webex.com/
2. Click **"Create a space"**
3. Name: "Jenkins CI/CD Notifications"
4. Click "Create"

#### 3.2 Create Incoming Webhook

1. In your space, click the space name at the top
2. Click **"Apps"** tab
3. Search for "Incoming Webhooks"
4. Click **"Add"**
5. Name: "Jenkins Build Bot"
6. Click **"Add"**
7. **IMPORTANT**: Copy the Webhook URL (you'll need this next!)

Example webhook URL:
```
https://webexapis.com/v1/webhooks/incoming/Y2lzY29zcGFyazovL...
```

#### 3.3 Test WebEx Webhook

```bash
# Test the webhook (replace with your webhook URL)
curl -X POST "YOUR_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"markdown": "✅ **Test Message from Jenkins Setup**"}'
```

You should see a message appear in your WebEx space!

---

### STEP 4: Configure Jenkins Credentials for WebEx (5 minutes)

1. In Jenkins, go to **Manage Jenkins** → **Credentials**
2. Click **(global)** domain
3. Click **Add Credentials**
4. Configure:
   - **Kind**: Secret text
   - **Scope**: Global
   - **Secret**: Paste your WebEx webhook URL
   - **ID**: `webex-webhook-url` (MUST be exactly this!)
   - **Description**: WebEx Webhook for Build Notifications
5. Click **Create**

**Verify**: You should see the credential listed with ID `webex-webhook-url`

---

### STEP 5: Set Up ngrok (15 minutes)

#### 5.1 Download and Install ngrok

```bash
cd /home/jake/cicd-assignment

# Download ngrok for Linux
curl -o ngrok.tar.gz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar -xzf ngrok.tar.gz

# Make executable
chmod +x ngrok

# Verify
./ngrok version
```

#### 5.2 Get ngrok Auth Token

1. Go to https://ngrok.com/
2. Sign up / Log in
3. Go to **Dashboard** → **Your Authtoken**
4. Copy your authtoken

#### 5.3 Configure ngrok

```bash
cd /home/jake/cicd-assignment

# Add your authtoken (replace YOUR_AUTH_TOKEN)
./ngrok authtoken YOUR_AUTH_TOKEN
```

#### 5.4 Start ngrok Tunnel

Open a **NEW terminal** and run:

```bash
cd /home/jake/cicd-assignment

# Start ngrok tunnel to Jenkins
./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite
```

**Keep this terminal open!** You'll see output like:

```
Forwarding   https://a1b2-c3d4.ngrok-free.app -> http://jenkins.15.204.74.157.nip.io
```

#### 5.5 Get Your ngrok URL

In another terminal:

```bash
# Get the ngrok public URL
curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*\.ngrok-free\.app'
```

**Save this URL!** You'll need it for GitHub webhook.

#### 5.6 Access ngrok Web Interface

Open http://127.0.0.1:4040 in your browser. This shows all incoming requests to your tunnel (important for the recording!).

---

### STEP 6: Create Jenkins Pipeline Job (10 minutes)

1. In Jenkins, click **New Item**
2. Enter item name: `cicd-assignment-pipeline`
3. Select **Pipeline**
4. Click **OK**

#### Configure the Pipeline:

**General Section:**
- ✅ Check **GitHub project**
- Project URL: `https://github.com/YOUR_USERNAME/cicd-assignment` (your GitHub repo URL)

**Build Triggers:**
- ✅ Check **GitHub hook trigger for GITScm polling**

**Pipeline Section:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
- Credentials: (leave as none if public repo)
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`

**Save the job!**

#### Test Manual Build:

1. Click **Build Now**
2. Click the build number (e.g., #1)
3. Click **Console Output**
4. Verify:
   - ✅ Code is checked out
   - ✅ Python version is displayed
   - ✅ Tests run successfully
   - ✅ Application runs
   - ✅ WebEx notification is sent

---

### STEP 7: Configure GitHub Webhook (5 minutes)

1. Go to your GitHub repository
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure:
   - **Payload URL**: `https://YOUR-NGROK-URL/github-webhook/`
     - Example: `https://a1b2-c3d4.ngrok-free.app/github-webhook/`
     - **MUST include /github-webhook/ and trailing slash!**
   - **Content type**: `application/json`
   - **Which events**: Just the push event
   - ✅ **Active**: Checked
4. Click **Add webhook**

**Verify**: You should see a green checkmark next to the webhook after a few seconds.

---

### STEP 8: Test the Complete CI/CD Pipeline (5 minutes)

Now test the entire workflow!

#### 8.1 Make Sure Everything is Ready:

- [ ] Jenkins is accessible
- [ ] GitHub repository is set up
- [ ] ngrok tunnel is running
- [ ] ngrok web interface is open (http://127.0.0.1:4040)
- [ ] WebEx space is open
- [ ] GitHub webhook is configured

#### 8.2 Make a Code Change:

```bash
cd /home/jake/cicd-assignment

# Edit app.py to add a comment or change print message
nano app.py

# Or use a simple echo to add a comment
echo "# Test change for CI/CD pipeline" >> app.py

# Commit and push
git add app.py
git commit -m "Test: Trigger CI/CD pipeline"
git push origin main
```

#### 8.3 Verify the Pipeline:

1. **GitHub**: Should show commit timestamp as "now"
2. **ngrok Web Interface** (http://127.0.0.1:4040): Should show incoming POST request from GitHub
3. **Jenkins**: Should automatically start build #2
4. **Jenkins Console**: Should show:
   - Checkout from GitHub
   - Python tests running
   - All tests passing
   - Build SUCCESS
5. **WebEx Space**: Should receive success notification

**Success!** Your CI/CD pipeline is working!

---

## Recording Your Demo (Screen Recording Requirements)

### What to Show:

1. **Terminal Window** with git commands
2. **GitHub Repository** showing commit timestamp "now" **(5 points)**
3. **ngrok Web Interface** (http://127.0.0.1:4040) showing webhook **(10 points)**
4. **Jenkins** automatically triggering build **(10 points)**
5. **Jenkins Console Output** showing all tests passing **(10 points)**
6. **WebEx Space** receiving notification **(5 points)**

### Recording Steps:

1. **Arrange your screen**:
   - Terminal (for git commands)
   - Browser with tabs: GitHub, ngrok, Jenkins, WebEx

2. **Start recording**

3. **Execute the test**:
   ```bash
   cd /home/jake/cicd-assignment
   echo "# Demo change - $(date)" >> app.py
   git add app.py
   git commit -m "Demo: Complete CI/CD pipeline test"
   git push origin main
   ```

4. **Show each component**:
   - GitHub commit (timestamp: "now")
   - ngrok inspector (incoming webhook)
   - Jenkins (automatic trigger)
   - Jenkins console (tests passing)
   - WebEx (notification received)

5. **Stop recording**

---

## Troubleshooting

### Build Fails: "python3: command not found"
```bash
# Verify Python is installed in Jenkins
kubectl exec -n cicd-assignment -it $(kubectl get pod -n cicd-assignment -o jsonpath='{.items[0].metadata.name}') -- python3 --version
```

### Webhook Not Triggering Jenkins
- Check GitHub webhook has green checkmark
- Verify webhook URL has `/github-webhook/` with trailing slash
- Check ngrok is running
- View ngrok web interface for incoming requests

### WebEx Notification Not Sent
- Verify credential ID is exactly `webex-webhook-url`
- Test webhook URL manually with curl
- Check Jenkins console output for curl errors

### ngrok Session Expired
- Free ngrok URLs change on restart
- Update GitHub webhook with new URL
- Restart ngrok tunnel

---

## Quick Reference

**Jenkins**: http://jenkins.15.204.74.157.nip.io
**Jenkins Password**: `8c019e08475445a68a4bc66abf310a69`
**ngrok Web UI**: http://127.0.0.1:4040

**Important Files:**
- [app.py](app.py) - Python calculator application
- [test_app.py](test_app.py) - Unit tests
- [Jenkinsfile](Jenkinsfile) - Pipeline definition
- [requirements.txt](requirements.txt) - Python dependencies

**Kubernetes Commands:**
```bash
# View all resources
kubectl get all -n cicd-assignment

# View logs
kubectl logs -n cicd-assignment deployment/jenkins -f

# Restart Jenkins
kubectl rollout restart deployment/jenkins -n cicd-assignment
```

---

## Success Criteria

✅ Code pushed to GitHub
✅ GitHub webhook configured
✅ ngrok exposing Jenkins
✅ Jenkins automatically triggered by GitHub push
✅ All Python unit tests pass
✅ Build completes successfully
✅ WebEx receives notification
✅ Screen recording shows complete flow

**Total Points: 40**

Good luck with your assignment! 🚀
