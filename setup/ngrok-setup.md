# ngrok Setup Guide

## What is ngrok?

ngrok creates a secure tunnel from a public URL to your localhost, allowing GitHub webhooks to reach your local Jenkins instance.

## Step 1: Install ngrok

### Option 1: Download from ngrok website

```bash
# Download ngrok
cd /home/jake/cicd-assignment
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar xvzf ngrok-v3-stable-linux-amd64.tgz

# Make executable
chmod +x ngrok
```

### Option 2: Using package manager

```bash
# Using yay (for Arch Linux)
yay -S ngrok

# Or download binary
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

## Step 2: Sign Up for ngrok Account

1. Go to https://ngrok.com/
2. Sign up for a free account
3. Get your authtoken from the dashboard

## Step 3: Configure ngrok

```bash
# Add your authtoken
./ngrok authtoken YOUR_AUTH_TOKEN

# Or if installed globally
ngrok authtoken YOUR_AUTH_TOKEN
```

## Step 4: Start ngrok Tunnel

```bash
# Make sure Jenkins is running on port 8080
docker ps | grep jenkins

# Start ngrok tunnel to Jenkins
./ngrok http 8080

# Or if installed globally
ngrok http 8080
```

## Step 5: Note the ngrok URL

After starting ngrok, you'll see output like:

```
ngrok by @inconshreveable

Session Status                online
Account                       your_email@example.com
Version                       3.x.x
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://xxxx-xx-xx-xx-xx.ngrok.io -> http://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

**Important**: Copy the HTTPS forwarding URL (e.g., `https://xxxx-xx-xx-xx-xx.ngrok.io`)

This is your public Jenkins URL that GitHub will use for webhooks!

## Step 6: Keep ngrok Running

ngrok must stay running for the webhook to work. Open a new terminal for other commands.

## Step 7: Monitor ngrok Traffic

1. Access the ngrok web interface: http://127.0.0.1:4040
2. This shows all HTTP requests coming through the tunnel
3. You'll see GitHub webhook requests here!

## Using ngrok in Production

For longer sessions or production use:

### Keep ngrok running in background:

```bash
# Using screen
screen -S ngrok
./ngrok http 8080
# Press Ctrl+A, then D to detach

# Reattach with
screen -r ngrok
```

### Using nohup:

```bash
nohup ./ngrok http 8080 > ngrok.log 2>&1 &
```

### Using systemd service:

Create `/etc/systemd/system/ngrok.service`:

```ini
[Unit]
Description=ngrok
After=network.target

[Service]
Type=simple
User=jake
WorkingDirectory=/home/jake/cicd-assignment
ExecStart=/home/jake/cicd-assignment/ngrok http 8080
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl start ngrok
sudo systemctl enable ngrok
sudo systemctl status ngrok
```

## Troubleshooting

### ngrok not connecting:
```bash
# Check if Jenkins is running
curl http://localhost:8080

# Check ngrok status
curl http://127.0.0.1:4040/api/tunnels
```

### View ngrok logs:
```bash
# If running in foreground, logs are displayed
# If running in background with nohup:
tail -f ngrok.log
```

### Get current ngrok URL programmatically:
```bash
curl http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url'
```

## Important Notes

1. **Free tier limitations**:
   - URL changes every time you restart ngrok
   - Session timeout after 8 hours
   - Limited connections

2. **For assignment**:
   - Keep ngrok running during your demo
   - Make sure to update GitHub webhook if URL changes
   - Record the ngrok web interface showing webhook traffic

3. **Security**:
   - ngrok URL is public - don't share sensitive info
   - Use HTTPS forwarding URL for webhooks
   - Consider adding authentication in Jenkins
