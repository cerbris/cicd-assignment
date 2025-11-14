# GitHub Setup Guide

## Step 1: Create GitHub Repository

1. Go to https://github.com/
2. Click on **+** (top right) > **New repository**
3. Fill in:
   - Repository name: `cicd-assignment`
   - Description: "CI/CD Pipeline with Jenkins, ngrok, and WebEx"
   - Visibility: **Public** or **Private**
   - Do NOT initialize with README (we'll push existing code)
4. Click **Create repository**

## Step 2: Initialize Local Git Repository

```bash
# Navigate to project directory
cd /home/jake/cicd-assignment

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Python calculator with unit tests"

# Add remote origin (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/cicd-assignment.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Configure GitHub Webhook

**Important**: Make sure Jenkins and ngrok are running first!

1. **Get your ngrok URL**:
```bash
# If ngrok is running, get the URL
curl http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url'

# Or check the ngrok terminal output
# It will show something like: https://xxxx-xx-xx-xx-xx.ngrok.io
```

2. **In GitHub repository**:
   - Go to your repository
   - Click **Settings** (top menu)
   - Click **Webhooks** (left sidebar)
   - Click **Add webhook**

3. **Configure webhook**:
   - **Payload URL**: `https://YOUR-NGROK-URL/github-webhook/`
     - Example: `https://a1b2-1-2-3-4.ngrok.io/github-webhook/`
     - **Important**: Include the trailing slash!

   - **Content type**: `application/json`

   - **Secret**: Leave empty or set a secret (optional)

   - **Which events would you like to trigger this webhook?**
     - Select **Just the push event**

   - **Active**: Check this box ✓

4. Click **Add webhook**

## Step 4: Verify Webhook

1. After adding webhook, GitHub will send a test ping
2. You should see:
   - Green checkmark next to webhook = Success!
   - Red X = There's a problem

3. **Check webhook deliveries**:
   - Click on the webhook you just created
   - Scroll down to **Recent Deliveries**
   - You should see a ping event with response code 200

4. **Check ngrok**:
   - Open http://127.0.0.1:4040 in browser
   - You should see the webhook request from GitHub

5. **Check Jenkins**:
   - The webhook should be received by Jenkins
   - Check Jenkins logs: `docker logs -f jenkins-cicd`

## Step 5: Test the Webhook

Make a small change to test the pipeline:

```bash
cd /home/jake/cicd-assignment

# Make a small change
echo "# Updated at $(date)" >> README.md

# Commit and push
git add README.md
git commit -m "Test webhook trigger"
git push origin main
```

**What should happen**:
1. ✅ Code is committed to GitHub
2. ✅ GitHub sends webhook to ngrok URL
3. ✅ ngrok forwards to Jenkins
4. ✅ Jenkins triggers build automatically
5. ✅ Build runs and tests execute
6. ✅ WebEx receives notification

**Verify**:
- GitHub: Check timestamp shows "now"
- ngrok: http://127.0.0.1:4040 shows incoming request
- Jenkins: Build triggered automatically
- WebEx: Notification received

## Step 6: GitHub Personal Access Token (Optional)

If your repository is private, create a Personal Access Token:

1. GitHub Settings > **Developer settings** > **Personal access tokens** > **Tokens (classic)**
2. Click **Generate new token** > **Generate new token (classic)**
3. Give it a name: "Jenkins CI/CD"
4. Select scopes:
   - ✓ `repo` (Full control of private repositories)
   - ✓ `admin:repo_hook` (Full control of repository hooks)
5. Click **Generate token**
6. **Copy the token** - you won't see it again!

Use this token in Jenkins credentials as password when adding GitHub credentials.

## Troubleshooting Webhook Issues

### Webhook shows red X:

1. **Check ngrok is running**:
```bash
curl http://127.0.0.1:4040/api/tunnels
```

2. **Check Jenkins is accessible via ngrok**:
```bash
curl https://YOUR-NGROK-URL
```

3. **Verify webhook URL format**:
   - Should be: `https://YOUR-NGROK-URL/github-webhook/`
   - Include `/github-webhook/` path
   - Include trailing slash

### Webhook successful but Jenkins not triggering:

1. **Check Jenkins job configuration**:
   - Build Triggers > "GitHub hook trigger for GITScm polling" is checked
   - Repository URL matches GitHub repository
   - Branch specifier is correct

2. **Check Jenkins GitHub plugin**:
   - Manage Jenkins > Manage Plugins
   - Ensure "GitHub Integration Plugin" is installed

3. **View Jenkins logs**:
```bash
docker logs -f jenkins-cicd
```

### ngrok URL changed:

If you restart ngrok, the URL changes (free tier):

1. Get new ngrok URL
2. Update GitHub webhook with new URL
3. Test again

### GitHub webhook delivery failing:

1. Click on webhook in GitHub
2. Click on a failed delivery
3. View Request and Response
4. Check Response tab for error details

## Best Practices

1. **Keep ngrok running** during development
2. **Use HTTPS** ngrok URL (not HTTP)
3. **Include trailing slash** in webhook URL
4. **Monitor ngrok inspector** at http://127.0.0.1:4040
5. **Check Recent Deliveries** in GitHub after each push
6. **Protect sensitive data** - don't commit secrets
7. **Use meaningful commit messages** for better tracking

## Useful Git Commands

```bash
# Check status
git status

# View commit history
git log --oneline -5

# View remote URL
git remote -v

# Update remote URL
git remote set-url origin https://github.com/USERNAME/REPO.git

# Push changes
git add .
git commit -m "Your message"
git push origin main

# View last commit details
git show HEAD
```

## Repository Structure

Your repository should look like:

```
cicd-assignment/
├── .git/
├── .gitignore
├── app.py
├── test_app.py
├── Jenkinsfile
├── requirements.txt
├── docker-compose.yml
├── README.md
└── setup/
    ├── github-setup.md
    ├── jenkins-setup.md
    ├── ngrok-setup.md
    └── webex-setup.md
```

## Resources

- GitHub Webhooks Documentation: https://docs.github.com/en/webhooks
- Jenkins GitHub Plugin: https://plugins.jenkins.io/github/
- Testing Webhooks: https://docs.github.com/en/webhooks/testing-webhooks
