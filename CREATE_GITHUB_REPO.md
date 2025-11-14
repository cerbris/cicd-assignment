# Create GitHub Repository for CI/CD Assignment

## ✅ Git is Already Initialized!

Good news! I've already initialized git and created the initial commit with all your files.

**Current Status:**
- ✅ Git initialized
- ✅ Files committed to local repository
- ✅ Branch set to `main`
- ⏳ Remote added: `git@github.com:cerbris/cicd-assignment.git`

## 🔧 What You Need to Do

### Option 1: Create Repository via GitHub Web Interface (Recommended - 2 minutes)

1. **Go to GitHub**: https://github.com/new
2. **Repository settings**:
   - Owner: `cerbris`
   - Repository name: `cicd-assignment`
   - Description: `CI/CD Pipeline Demo with Jenkins and WebEx`
   - Visibility: **Public** (recommended for easier webhook setup)
   - **DO NOT** initialize with README, .gitignore, or license
3. **Click "Create repository"**

4. **Push your code** (run from this directory):
   ```bash
   cd /home/jake/cicd-assignment
   git push -u origin main
   ```

5. **Verify**: Visit https://github.com/cerbris/cicd-assignment to see your code!

---

### Option 2: Create Repository via GitHub CLI (If you have `gh` installed)

```bash
cd /home/jake/cicd-assignment

# Create the repository
gh repo create cerbris/cicd-assignment --public --description "CI/CD Pipeline Demo with Jenkins and WebEx"

# Push your code
git push -u origin main
```

---

### Option 3: Create Repository via API

```bash
cd /home/jake/cicd-assignment

# You'll need a GitHub personal access token
# Replace YOUR_TOKEN with your actual token
curl -X POST https://api.github.com/orgs/cerbris/repos \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{
    "name": "cicd-assignment",
    "description": "CI/CD Pipeline Demo with Jenkins and WebEx",
    "private": false
  }'

# Then push
git push -u origin main
```

---

## After Creating the Repository

Once you've created the repository and pushed your code:

1. **Verify on GitHub**: https://github.com/cerbris/cicd-assignment

2. **Continue with the assignment**: Open [START_HERE.md](START_HERE.md) and proceed to Step 3 (Setup WebEx)

---

## Git Commands Reference

**Already done for you:**
```bash
✅ git init
✅ git add .
✅ git commit -m "Initial commit: CI/CD pipeline with Jenkins and WebEx integration"
✅ git remote add origin git@github.com:cerbris/cicd-assignment.git
✅ git branch -M main
```

**To push after creating GitHub repo:**
```bash
git push -u origin main
```

**To make future commits:**
```bash
git add .
git commit -m "Your commit message"
git push
```

---

## What Files Are Committed?

All assignment files are ready:
- ✅ Python code: `app.py`, `test_app.py`
- ✅ Jenkins pipeline: `Jenkinsfile`
- ✅ Kubernetes manifests: `k8s/*.yaml`
- ✅ Documentation: All `.md` files
- ✅ Helper scripts: `*.sh` files

**Total: 32 files, 4384 lines of code**

---

## Troubleshooting

### SSH Key Issues

If you get "Permission denied (publickey)":

```bash
# Check if SSH key exists
ls -la ~/.ssh/

# Test GitHub connection
ssh -T git@github.com

# If needed, add your SSH key to GitHub:
# 1. Copy your public key
cat ~/.ssh/id_rsa.pub

# 2. Add to GitHub: https://github.com/settings/keys
```

### Using HTTPS Instead of SSH

If you prefer HTTPS:

```bash
# Remove SSH remote
git remote remove origin

# Add HTTPS remote
git remote add origin https://github.com/cerbris/cicd-assignment.git

# Push
git push -u origin main
```

---

## Next Steps

After successfully pushing to GitHub:

1. ✅ Mark "Set up GitHub repository" as complete
2. 📋 Continue with [START_HERE.md](START_HERE.md) - Step 3: Setup WebEx
3. 🎯 Follow the remaining steps to complete your 40-point assignment!

Repository URL: https://github.com/cerbris/cicd-assignment
