# Jenkins Access to Private GitHub Repository

## Method 1: Personal Access Token (Recommended - 10 minutes)

### Step 1: Create GitHub Personal Access Token

1. **Go to GitHub**: https://github.com/settings/tokens
2. Click **Generate new token** → **Generate new token (classic)**
3. **Configure token**:
   - Note: `Jenkins CI/CD Access`
   - Expiration: 90 days (or custom)
   - **Select scopes**:
     - ✅ `repo` (Full control of private repositories)
       - ✅ repo:status
       - ✅ repo_deployment
       - ✅ public_repo
       - ✅ repo:invite
       - ✅ security_events
4. Click **Generate token**
5. **COPY THE TOKEN** - You won't see it again!

Example token: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### Step 2: Add Credentials to Jenkins

1. **In Jenkins**: http://jenkins.15.204.74.157.nip.io
2. Go to **Manage Jenkins** → **Credentials**
3. Click **System** → **(global)** domain
4. Click **Add Credentials**
5. **Configure**:
   - **Kind**: Username with password
   - **Scope**: Global
   - **Username**: Your GitHub username (e.g., `cerbris`)
   - **Password**: Paste the Personal Access Token
   - **ID**: `github-credentials`
   - **Description**: `GitHub Personal Access Token for private repos`
6. Click **Create**

### Step 3: Update Jenkins Pipeline Job

1. Go to your pipeline: `cicd-assignment-pipeline`
2. Click **Configure**
3. In **Pipeline** section, under **Repositories**:
   - Repository URL: `https://github.com/cerbris/cicd-assignment.git`
   - **Credentials**: Select **cerbris/****** (github-credentials)**
   - Branch: `*/main`
4. Click **Save**

### Step 4: Test

Click **Build Now** and check Console Output.

Should show:
```
Cloning the remote Git repository
Cloning repository https://github.com/cerbris/cicd-assignment.git
...
Checking out Revision abc123...
```

---

## Method 2: SSH Key (Alternative - 15 minutes)

### Step 1: Generate SSH Key in Jenkins Container

```bash
# Get Jenkins pod name
POD=$(kubectl get pods -n cicd-assignment -o jsonpath='{.items[0].metadata.name}')

# Generate SSH key
kubectl exec -n cicd-assignment $POD -- bash -c "
  mkdir -p /var/jenkins_home/.ssh
  ssh-keygen -t rsa -b 4096 -f /var/jenkins_home/.ssh/id_rsa -N ''
  cat /var/jenkins_home/.ssh/id_rsa.pub
"
```

Copy the public key output.

### Step 2: Add SSH Key to GitHub

1. Go to: https://github.com/settings/keys
2. Click **New SSH key**
3. Title: `Jenkins CI/CD Server`
4. Key: Paste the public key
5. Click **Add SSH key**

### Step 3: Get Private Key

```bash
kubectl exec -n cicd-assignment $POD -- cat /var/jenkins_home/.ssh/id_rsa
```

Copy the entire private key (including `-----BEGIN` and `-----END` lines).

### Step 4: Add SSH Credential to Jenkins

1. **In Jenkins**: Manage Jenkins → Credentials → System → (global)
2. Click **Add Credentials**
3. **Configure**:
   - **Kind**: SSH Username with private key
   - **Scope**: Global
   - **ID**: `github-ssh-key`
   - **Description**: GitHub SSH Key
   - **Username**: `git`
   - **Private Key**: Select "Enter directly"
   - Paste the private key
4. Click **Create**

### Step 5: Update Jenkins Pipeline Job

1. Pipeline → Configure
2. Repository URL: `git@github.com:cerbris/cicd-assignment.git` (SSH format!)
3. Credentials: Select **git (github-ssh-key)**
4. Save

---

## Recommendation for Assignment

**Use Option 1 (Personal Access Token)** because:
- ✅ Simpler to set up
- ✅ Easier to revoke/regenerate
- ✅ No SSH key management
- ✅ Works with HTTPS URLs

---

## Troubleshooting

### "Failed to connect to repository"

**Check:**
1. Token has `repo` scope
2. Token is not expired
3. Credential ID matches what you selected
4. Repository URL is correct

**Test credential**:
```bash
# From any machine with the token
git clone https://YOUR_TOKEN@github.com/cerbris/cicd-assignment.git
```

### "Host key verification failed" (SSH)

Add GitHub to known hosts:
```bash
kubectl exec -n cicd-assignment $POD -- bash -c "
  ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts
"
```

### Permission denied

- Verify SSH key is added to GitHub
- Check username is `git` (not your GitHub username)
- Verify private key is complete

---

## Quick Comparison

| Method | Setup Time | Security | Best For |
|--------|-----------|----------|----------|
| **Public Repo** | 2 min | Low | Demos, learning |
| **Personal Token** | 10 min | Medium | Most cases |
| **SSH Key** | 15 min | High | Production |

---

## For Your Assignment

**Recommendation**: Make the repository public

The assignment doesn't require a private repository, and using a public repo:
- ✅ Saves 10+ minutes
- ✅ Avoids credential issues
- ✅ Simplifies troubleshooting
- ✅ Is standard for demo projects

See: [MAKE_REPO_PUBLIC.md](MAKE_REPO_PUBLIC.md)

---

## If You Choose to Keep It Private

Follow **Method 1: Personal Access Token** above.

**Important**: After adding credentials, update your pipeline job to use them!
