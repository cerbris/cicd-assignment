# CI/CD Pipeline Setup Checklist

Print this page or keep it open while setting up your pipeline!

## 🎯 Pre-Setup

- [ ] Docker installed and running
- [ ] Git installed and configured
- [ ] GitHub account created
- [ ] WebEx account created
- [ ] Code downloaded to `/home/jake/cicd-assignment/`

---

## 1️⃣ GitHub Setup (5 minutes)

- [ ] Created GitHub repository named `cicd-assignment`
- [ ] Initialized git in local directory
- [ ] Added remote origin
- [ ] Pushed initial commit
- [ ] Code visible on GitHub

**Commands:**
```bash
cd /home/jake/cicd-assignment
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git
git push -u origin main
```

---

## 2️⃣ Jenkins Setup (10 minutes)

- [ ] Started Jenkins container
- [ ] Got initial admin password
- [ ] Completed initial setup wizard
- [ ] Installed suggested plugins
- [ ] Created admin user
- [ ] Installed Python in Jenkins container
- [ ] Created pipeline job `cicd-assignment-pipeline`
- [ ] Configured job with GitHub repository
- [ ] Enabled "GitHub hook trigger for GITScm polling"
- [ ] Set pipeline script path to `Jenkinsfile`
- [ ] Ran manual build successfully

**Commands:**
```bash
./scripts/start-jenkins.sh
docker exec -it -u root jenkins-cicd bash
apt-get update && apt-get install -y python3 python3-pip
exit
```

**URLs:**
- Jenkins: http://localhost:8080

---

## 3️⃣ WebEx Setup (5 minutes)

- [ ] Created WebEx space "Jenkins CI/CD Notifications"
- [ ] Added Incoming Webhooks app to space
- [ ] Named webhook "Jenkins Build Bot"
- [ ] Copied webhook URL
- [ ] Tested webhook with script
- [ ] Added webhook URL to Jenkins credentials
  - ID: `webex-webhook-url`
  - Type: Secret text
- [ ] Test message received in WebEx

**Commands:**
```bash
./scripts/test-webex.sh
```

---

## 4️⃣ ngrok Setup (5 minutes)

- [ ] Signed up at ngrok.com
- [ ] Copied authtoken from dashboard
- [ ] Configured ngrok with authtoken
- [ ] Started ngrok tunnel
- [ ] Copied ngrok HTTPS URL
- [ ] Verified Jenkins accessible via ngrok
- [ ] Opened ngrok inspector at http://127.0.0.1:4040

**Commands:**
```bash
./ngrok authtoken YOUR_AUTH_TOKEN
./scripts/start-ngrok.sh
# In another terminal:
./scripts/get-ngrok-url.sh
```

**URLs:**
- ngrok Inspector: http://127.0.0.1:4040

---

## 5️⃣ GitHub Webhook (5 minutes)

- [ ] Opened GitHub repository settings
- [ ] Navigated to Webhooks
- [ ] Clicked "Add webhook"
- [ ] Pasted ngrok URL + `/github-webhook/`
- [ ] Set content type to `application/json`
- [ ] Selected "Just the push event"
- [ ] Enabled "Active"
- [ ] Saved webhook
- [ ] Verified green checkmark appears
- [ ] Checked Recent Deliveries shows successful ping

**Webhook URL format:**
```
https://YOUR-NGROK-URL/github-webhook/
```
⚠️ Don't forget the trailing slash!

---

## 6️⃣ End-to-End Test (5 minutes)

- [ ] Made small code change locally
- [ ] Committed change
- [ ] Pushed to GitHub
- [ ] Verified commit appears on GitHub
- [ ] Checked ngrok inspector shows webhook
- [ ] Jenkins build triggered automatically
- [ ] Build completed successfully
- [ ] All 8 tests passed
- [ ] WebEx notification received

**Commands:**
```bash
./scripts/test-pipeline.sh
```

---

## 7️⃣ Recording Preparation

### Windows to Open:

- [ ] Terminal (for git commands)
- [ ] GitHub repository page
- [ ] ngrok inspector (http://127.0.0.1:4040)
- [ ] Jenkins (http://localhost:8080)
- [ ] Jenkins console output page
- [ ] WebEx space

### Verify Before Recording:

- [ ] Jenkins is running
- [ ] ngrok is running
- [ ] WebEx webhook is configured
- [ ] GitHub webhook is configured
- [ ] Manual test completed successfully
- [ ] Screen recorder ready

---

## 8️⃣ Recording Checklist (40 points)

### Show in Recording:

1. **Terminal - Git Commands**
   - [ ] `git add README.md`
   - [ ] `git commit -m "Test message"`
   - [ ] `git push origin main`

2. **GitHub - Commit Timestamp** (5 points)
   - [ ] Navigate to repository
   - [ ] Show recent commit
   - [ ] Timestamp shows "now" or "seconds ago"

3. **ngrok Inspector** (10 points)
   - [ ] Open http://127.0.0.1:4040
   - [ ] Show POST request from github.com
   - [ ] Status 200 OK visible

4. **Jenkins - Auto Trigger** (10 points)
   - [ ] Show http://localhost:8080
   - [ ] Build appears automatically
   - [ ] Build number increments

5. **Jenkins - Console Output** (10 points)
   - [ ] Click on build
   - [ ] Click "Console Output"
   - [ ] Show all tests running
   - [ ] All 8 tests pass
   - [ ] Build SUCCESS message

6. **WebEx - Notification** (5 points)
   - [ ] Show WebEx space
   - [ ] Notification appears
   - [ ] Contains build status
   - [ ] Contains build number

---

## ✅ Success Criteria

Your pipeline is working if:

1. ✅ Pushing code to GitHub triggers Jenkins automatically
2. ✅ Jenkins pulls latest code from GitHub
3. ✅ All 8 unit tests run and pass
4. ✅ Application executes successfully
5. ✅ WebEx receives success notification
6. ✅ ngrok shows the webhook traffic

---

## 🔧 Quick Commands Reference

```bash
# Start Jenkins
./scripts/start-jenkins.sh

# Start ngrok
./scripts/start-ngrok.sh

# Get ngrok URL
./scripts/get-ngrok-url.sh

# Test WebEx
./scripts/test-webex.sh

# Test pipeline
./scripts/test-pipeline.sh

# View Jenkins logs
docker logs -f jenkins-cicd

# Restart Jenkins
docker restart jenkins-cicd

# Run tests locally
python3 -m unittest test_app.py -v
```

---

## 🆘 Troubleshooting Quick Check

If something doesn't work, verify:

### Jenkins Issues:
- [ ] Docker is running: `docker ps`
- [ ] Jenkins container is running: `docker ps | grep jenkins`
- [ ] Can access Jenkins: http://localhost:8080

### ngrok Issues:
- [ ] ngrok is running: `curl http://127.0.0.1:4040/api/tunnels`
- [ ] Jenkins accessible via ngrok URL
- [ ] URL hasn't changed (restarts change URL on free tier)

### Webhook Issues:
- [ ] GitHub webhook URL includes `/github-webhook/`
- [ ] GitHub webhook URL has trailing slash
- [ ] GitHub webhook shows green checkmark
- [ ] Recent Deliveries shows 200 responses

### Build Issues:
- [ ] Jenkins job has "GitHub hook trigger" enabled
- [ ] Repository URL is correct
- [ ] Branch specifier matches (`*/main` or `*/master`)
- [ ] Jenkinsfile exists in repository

### WebEx Issues:
- [ ] Webhook URL is correct
- [ ] Credential ID is exactly `webex-webhook-url`
- [ ] Test script works: `./scripts/test-webex.sh`

---

## 📊 Time Estimates

| Phase | Time |
|-------|------|
| GitHub Setup | 5 min |
| Jenkins Setup | 10 min |
| WebEx Setup | 5 min |
| ngrok Setup | 5 min |
| GitHub Webhook | 5 min |
| Testing | 5 min |
| **Total Setup** | **35 min** |
| Recording | 10-15 min |

---

## 🎬 Recording Tips

1. **Before Recording:**
   - Test everything once
   - Close unnecessary windows
   - Clear terminal
   - Zoom in for readability

2. **During Recording:**
   - Speak clearly, explain actions
   - Wait for actions to complete
   - Point out key elements
   - Show timestamps and status codes

3. **Must Capture:**
   - Terminal with git push
   - GitHub timestamp
   - ngrok webhook event
   - Jenkins auto-trigger
   - Console with passing tests
   - WebEx notification

---

## ✨ Final Check Before Submission

- [ ] Recording shows all required elements
- [ ] Video is clear and readable
- [ ] Audio is clear (if narrated)
- [ ] All timestamps visible
- [ ] All 40 points demonstrated
- [ ] Recording uploaded/submitted

---

**Good luck! 🚀**

Remember: Use [QUICK_START.md](QUICK_START.md) for detailed instructions!