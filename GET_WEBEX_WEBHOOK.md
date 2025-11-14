# Get WebEx Webhook URL - Quick Guide

## Step 1: Access WebEx

Go to: https://teams.webex.com/

Sign in with your WebEx account

## Step 2: Create a Space

1. Click the **"+"** button or **"Create a space"**
2. Space name: `Jenkins CI/CD Notifications`
3. Click **"Create"**

## Step 3: Add Incoming Webhook App

1. In your new space, click the **space name** at the top
2. Click the **"Apps"** tab
3. In the search box, type: `Incoming Webhooks`
4. Click **"Add"** next to "Incoming Webhooks"
5. Webhook name: `Jenkins Build Bot`
6. Click **"Add"**

## Step 4: Copy the Webhook URL

You'll see a URL like this:

```
https://webexapis.com/v1/webhooks/incoming/Y2lzY29zcGFyazovL3VzL1dFQkhPT0svYWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY3ODkw
```

**COPY THIS ENTIRE URL!**

## Step 5: Test the Webhook

Test it immediately to make sure it works:

```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"markdown": "✅ **WebEx Integration Test**\n\nIf you see this, the webhook is working!"}' \
  "YOUR_WEBHOOK_URL_HERE"
```

Replace `YOUR_WEBHOOK_URL_HERE` with the actual URL you copied.

**You should see a message appear in your WebEx space!**

## Step 6: Give the URL to Me

Once you have the webhook URL, just paste it here and I'll:
1. Add it to Jenkins credentials automatically
2. Test the pipeline
3. Everything will work!

---

## Example Webhook URL Format

The URL will look like:
```
https://webexapis.com/v1/webhooks/incoming/Y2lzY29zcGFyazovL3VzL1dFQkhPT0svXXXXXXXXXXXX
```

The part after `/incoming/` is unique to your webhook.

---

## After You Get It

**Just paste the URL here and say "Here's my WebEx URL: <your-url>"**

I'll immediately:
- Add it to Jenkins
- Trigger a test build
- Show you the WebEx notification working!

---

## Troubleshooting

**Can't find Incoming Webhooks app?**
- Make sure you're signed in to WebEx
- Search exactly: `Incoming Webhooks`
- It's an official Cisco app

**Don't have WebEx account?**
- Sign up free at: https://www.webex.com/

**Webhook not working?**
- Make sure you copied the ENTIRE URL
- Include everything starting with `https://`
- Test with the curl command above

---

Ready? Go get your webhook URL and paste it here! 🚀
