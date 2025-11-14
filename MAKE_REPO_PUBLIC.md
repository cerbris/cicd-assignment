# Make GitHub Repository Public

## Quick Steps (2 minutes)

1. Go to: https://github.com/cerbris/cicd-assignment
2. Click **Settings** (top right)
3. Scroll down to **Danger Zone** (bottom of page)
4. Click **Change visibility**
5. Select **Make public**
6. Type the repository name to confirm: `cerbris/cicd-assignment`
7. Click **I understand, change repository visibility**

**Done!** Jenkins can now access the repository without credentials.

---

## Why This Works for Your Assignment

- ✅ No credentials needed in Jenkins
- ✅ Simpler webhook setup
- ✅ Easier to debug
- ✅ Common for demo/learning projects
- ✅ Assignment doesn't require private repo

**After making it public:**
- Jenkins will automatically pull code
- No additional configuration needed
- Continue with pipeline setup as planned

---

## Verify It's Public

Go to: https://github.com/cerbris/cicd-assignment

You should see:
- 🌐 Public badge (not 🔒 Private)
- Repository is accessible without login

---

**Recommended**: Use this option for your assignment! It's faster and simpler.

See [JENKINS_PRIVATE_REPO.md](JENKINS_PRIVATE_REPO.md) if you need private repo access.
