# Jenkins Setup Guide

## Step 1: Install Docker (if not already installed)

```bash
# Check if Docker is installed
docker --version

# If not installed, install Docker
sudo pacman -S docker docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

## Step 2: Start Jenkins with Docker Compose

```bash
# Navigate to project directory
cd /home/jake/cicd-assignment

# Start Jenkins container
docker-compose up -d

# Check if Jenkins is running
docker ps

# View Jenkins logs
docker logs -f jenkins-cicd
```

## Step 3: Initial Jenkins Setup

1. **Get the initial admin password:**
```bash
docker exec jenkins-cicd cat /var/jenkins_home/secrets/initialAdminPassword
```

2. **Access Jenkins:**
   - Open browser: http://localhost:8080
   - Enter the initial admin password
   - Choose "Install suggested plugins"
   - Create your first admin user

## Step 4: Install Required Plugins

1. Go to **Manage Jenkins** > **Manage Plugins**
2. Install the following plugins:
   - GitHub Integration Plugin
   - Pipeline Plugin
   - Git Plugin
   - Credentials Binding Plugin
   - HTTP Request Plugin
   - Timestamper
   - Build Timeout
   - Workspace Cleanup Plugin

3. Restart Jenkins after installation:
```bash
docker restart jenkins-cicd
```

## Step 5: Install Python in Jenkins Container

```bash
# Access Jenkins container
docker exec -it -u root jenkins-cicd bash

# Install Python and pip
apt-get update
apt-get install -y python3 python3-pip python3-venv

# Verify installation
python3 --version
pip3 --version

# Exit container
exit
```

## Step 6: Configure Jenkins Credentials for WebEx

1. Go to **Manage Jenkins** > **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Fill in:
   - Kind: **Secret text**
   - Scope: **Global**
   - Secret: **[Your WebEx Webhook URL]**
   - ID: **webex-webhook-url**
   - Description: **WebEx Webhook URL for notifications**
5. Click **OK**

## Step 7: Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter item name: **cicd-assignment-pipeline**
3. Select **Pipeline**
4. Click **OK**

5. In the pipeline configuration:
   - **General**:
     - Check **GitHub project**
     - Project url: `https://github.com/YOUR_USERNAME/cicd-assignment`

   - **Build Triggers**:
     - Check **GitHub hook trigger for GITScm polling**

   - **Pipeline**:
     - Definition: **Pipeline script from SCM**
     - SCM: **Git**
     - Repository URL: `https://github.com/YOUR_USERNAME/cicd-assignment.git`
     - Credentials: Add your GitHub credentials if private repo
     - Branch Specifier: `*/main` or `*/master`
     - Script Path: `Jenkinsfile`

6. Click **Save**

## Step 8: Configure GitHub Credentials (if needed)

If your repository is private:

1. Go to **Manage Jenkins** > **Manage Credentials**
2. Add GitHub credentials:
   - Kind: **Username with password**
   - Username: Your GitHub username
   - Password: Your GitHub Personal Access Token
   - ID: **github-credentials**
   - Description: **GitHub Credentials**

## Troubleshooting

### Check Jenkins logs:
```bash
docker logs -f jenkins-cicd
```

### Restart Jenkins:
```bash
docker restart jenkins-cicd
```

### Access Jenkins container:
```bash
docker exec -it jenkins-cicd bash
```

### Check Jenkins configuration:
```bash
docker exec jenkins-cicd ls -la /var/jenkins_home/
```

## Useful Commands

```bash
# Stop Jenkins
docker-compose down

# Start Jenkins
docker-compose up -d

# View Jenkins logs
docker logs -f jenkins-cicd

# Remove Jenkins (including volumes)
docker-compose down -v
```
