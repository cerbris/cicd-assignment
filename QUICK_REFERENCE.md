# Quick Reference Card - CI/CD Assignment

## 🎯 Current Status

✅ **Jenkins Running**: http://jenkins.15.204.74.157.nip.io
✅ **Jenkins Password**: `8c019e08475445a68a4bc66abf310a69`
✅ **Python Installed**: Python 3.13.5 + pip
✅ **Code Ready**: app.py, test_app.py, Jenkinsfile all ready

## 📋 Quick Steps to Complete Assignment

### 1. Complete Jenkins Setup (5 min)
- Visit http://jenkins.15.204.74.157.nip.io
- Enter password: `8c019e08475445a68a4bc66abf310a69`
- Install suggested plugins
- Create admin user

### 2. Create GitHub Repository (5 min)
```bash
# On GitHub: Create new repository "cicd-assignment"
cd /home/jake/cicd-assignment
git init
git add .
git commit -m "Initial commit: CI/CD pipeline"
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git
git branch -M main
git push -u origin main
```

### 3. Setup WebEx (5 min)
- Go to https://teams.webex.com/
- Create space: "Jenkins CI/CD Notifications"
- Add "Incoming Webhooks" app
- Copy webhook URL

### 4. Add WebEx Webhook to Jenkins (2 min)
- Jenkins → Manage Jenkins → Credentials → Add Credentials
- Kind: Secret text
- Secret: [Your WebEx webhook URL]
- ID: `webex-webhook-url`

### 5. Setup ngrok (5 min)
```bash
cd /home/jake/cicd-assignment
./setup-ngrok.sh
./ngrok authtoken YOUR_AUTH_TOKEN
./ngrok http http://jenkins.15.204.74.157.nip.io --host-header=rewrite
```

In another terminal:
```bash
./get-webhook-url.sh
```

### 6. Create Jenkins Pipeline Job (5 min)
- New Item → "cicd-assignment-pipeline" → Pipeline
- ✓ GitHub project: `https://github.com/YOUR_USERNAME/cicd-assignment`
- ✓ GitHub hook trigger for GITScm polling
- Pipeline from SCM → Git
- Repository: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
- Branch: `*/main`
- Script Path: `Jenkinsfile`
- **Save & Build Now** to test!

### 7. Configure GitHub Webhook (2 min)
- GitHub repo → Settings → Webhooks → Add webhook
- Payload URL: `https://YOUR-NGROK-URL/github-webhook/`
- Content type: application/json
- Events: Just the push event
- Add webhook

### 8. Test & Record! (10 min)
```bash
cd /home/jake/cicd-assignment
echo "# Test change" >> app.py
git add app.py
git commit -m "Test: Complete CI/CD pipeline"
git push origin main
```

**Watch**:
1. GitHub shows "now" timestamp ✅ (5 pts)
2. ngrok http://127.0.0.1:4040 shows webhook ✅ (10 pts)
3. Jenkins auto-triggers build ✅ (10 pts)
4. Tests pass in console ✅ (10 pts)
5. WebEx gets notification ✅ (5 pts)

## 🛠️ Helper Scripts

```bash
# Setup ngrok
./setup-ngrok.sh

# Get webhook URL for GitHub
./get-webhook-url.sh
```

## 🔗 Important URLs

| Service | URL |
|---------|-----|
| Jenkins | http://jenkins.15.204.74.157.nip.io |
| ngrok Web UI | http://127.0.0.1:4040 |
| WebEx | https://teams.webex.com/ |
| ngrok Dashboard | https://dashboard.ngrok.com/ |

## 🐛 Quick Troubleshooting

**Jenkins won't load?**
```bash
kubectl get pods -n cicd-assignment
kubectl logs -n cicd-assignment deployment/jenkins
```

**Python not found in Jenkins?**
```bash
kubectl exec -n cicd-assignment -it $(kubectl get pod -n cicd-assignment -o jsonpath='{.items[0].metadata.name}') -- python3 --version
```

**Webhook not triggering?**
- Check GitHub webhook has green checkmark
- Verify URL has `/github-webhook/` with trailing slash
- Check ngrok web interface for requests

**WebEx not working?**
- Test with: `curl -X POST "YOUR_WEBHOOK_URL" -H 'Content-Type: application/json' -d '{"markdown": "Test"}'`
- Verify Jenkins credential ID is exactly `webex-webhook-url`

## 📁 Important Files

- [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md) - Detailed step-by-step guide
- [KUBERNETES_DEPLOYMENT.md](KUBERNETES_DEPLOYMENT.md) - Kubernetes deployment info
- [JENKINS_ACCESS.md](JENKINS_ACCESS.md) - Jenkins access details
- [app.py](app.py) - Python calculator app
- [test_app.py](test_app.py) - Unit tests
- [Jenkinsfile](Jenkinsfile) - Pipeline definition

## 🎬 Recording Checklist

Before recording:
- [ ] Jenkins accessible and configured
- [ ] GitHub repository created with code pushed
- [ ] WebEx space created with webhook configured
- [ ] ngrok running (keep terminal open!)
- [ ] ngrok web interface open (http://127.0.0.1:4040)
- [ ] Jenkins pipeline job created and tested manually
- [ ] GitHub webhook configured with ngrok URL

During recording show:
- [ ] Terminal with git commands
- [ ] GitHub commit with "now" timestamp (5 pts)
- [ ] ngrok web UI showing webhook request (10 pts)
- [ ] Jenkins auto-triggering build (10 pts)
- [ ] Console output with passing tests (10 pts)
- [ ] WebEx space receiving notification (5 pts)

**Total: 40 points** 🎯

---

Need help? Check [ASSIGNMENT_SETUP_STEPS.md](ASSIGNMENT_SETUP_STEPS.md) for detailed instructions!
