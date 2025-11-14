# CI/CD Pipeline Assignment

A complete CI/CD pipeline demonstrating automated testing and deployment with GitHub, Jenkins, ngrok, and WebEx integration.

[![Python](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![Jenkins](https://img.shields.io/badge/Jenkins-Docker-red.svg)](https://www.jenkins.io/)
[![Tests](https://img.shields.io/badge/Tests-8%20passing-brightgreen.svg)]()

## 🚀 Quick Start

**New to this project? Start here:**

1. **[QUICK_START.md](QUICK_START.md)** - Fast setup guide (recommended!)
2. **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed step-by-step instructions
3. **[ASSIGNMENT_SUMMARY.md](ASSIGNMENT_SUMMARY.md)** - Complete overview

**Start Jenkins and test:**
```bash
cd /home/jake/cicd-assignment
./scripts/start-jenkins.sh     # Start Jenkins
./scripts/start-ngrok.sh       # Start ngrok tunnel
./scripts/test-pipeline.sh     # Test the pipeline
```

## 📋 What's Included

### Python Application
- **Calculator** with 6 operations (add, subtract, multiply, divide, power, modulo)
- **8 unit tests** covering all operations and edge cases
- **100% test coverage** with error handling

### CI/CD Pipeline
- **GitHub** repository with webhook integration
- **Jenkins** running in Docker container
- **ngrok** tunnel for local development
- **WebEx bot** for build notifications
- **Automated testing** on every commit

## 🔄 Pipeline Flow

```
Developer → GitHub → Webhook → ngrok → Jenkins → Tests → WebEx
   (git)     (repo)   (POST)   (tunnel) (build)  (8/8)  (notify)
```

1. Commit code to GitHub
2. GitHub sends webhook
3. ngrok forwards to local Jenkins
4. Jenkins runs automated tests
5. WebEx notifies build status

## 📁 Project Structure

```
cicd-assignment/
├── app.py                   # Calculator application
├── test_app.py              # Unit tests (8 tests)
├── Jenkinsfile              # CI/CD pipeline definition
├── requirements.txt         # Python dependencies
├── docker-compose.yml       # Jenkins Docker config
│
├── README.md               # This file
├── QUICK_START.md          # Fast setup guide ⭐
├── SETUP_GUIDE.md          # Detailed guide
├── ASSIGNMENT_SUMMARY.md   # Complete overview
│
├── scripts/                # Helper scripts
│   ├── start-jenkins.sh    # Start Jenkins
│   ├── start-ngrok.sh      # Start ngrok
│   ├── get-ngrok-url.sh    # Get ngrok URL
│   ├── test-webex.sh       # Test WebEx webhook
│   └── test-pipeline.sh    # Test commit script
│
└── setup/                  # Detailed documentation
    ├── github-setup.md     # GitHub configuration
    ├── jenkins-setup.md    # Jenkins setup
    ├── ngrok-setup.md      # ngrok setup
    └── webex-setup.md      # WebEx bot setup
```

## 🎯 Assignment Requirements

This project fulfills all assignment requirements:

- [x] GitHub repository with Python code and unit tests
- [x] GitHub webhook configuration
- [x] Jenkins in Docker container
- [x] ngrok tunnel for webhook delivery
- [x] Jenkins plugins and configuration
- [x] WebEx bot integration
- [x] Automated pipeline trigger
- [x] Complete end-to-end testing

### Screen Recording Checklist (40 points)
- [ ] Code commit to GitHub with timestamp (5 pts)
- [ ] ngrok showing webhook traffic (10 pts)
- [ ] Jenkins auto-triggering build (10 pts)
- [ ] Console output with passing tests (10 pts)
- [ ] WebEx notification received (5 pts)

## 💻 Local Testing

### Run the application:
```bash
python3 app.py
```

Output:
```
Calculator Demo
========================================
5 + 3 = 8
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
17 % 5 = 2
========================================
```

### Run the tests:
```bash
python3 -m unittest test_app.py -v
```

Output:
```
test_add ... ok
test_divide ... ok
test_divide_by_zero ... ok
test_modulo ... ok
test_modulo_by_zero ... ok
test_multiply ... ok
test_power ... ok
test_subtract ... ok

Ran 8 tests in 0.000s
OK
```

## 🛠️ Technologies Used

- **Python 3.x** - Application and testing
- **unittest** - Python testing framework
- **Jenkins** - CI/CD automation
- **Docker** - Container platform
- **ngrok** - Secure tunneling
- **WebEx** - Team notifications
- **GitHub** - Version control and webhooks

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [QUICK_START.md](QUICK_START.md) | Fast setup in 5 steps |
| [SETUP_GUIDE.md](SETUP_GUIDE.md) | Comprehensive guide |
| [ASSIGNMENT_SUMMARY.md](ASSIGNMENT_SUMMARY.md) | Complete overview |
| [setup/github-setup.md](setup/github-setup.md) | GitHub details |
| [setup/jenkins-setup.md](setup/jenkins-setup.md) | Jenkins details |
| [setup/ngrok-setup.md](setup/ngrok-setup.md) | ngrok details |
| [setup/webex-setup.md](setup/webex-setup.md) | WebEx details |

## 🔧 Helper Scripts

All scripts are in the `scripts/` directory:

```bash
./scripts/start-jenkins.sh   # Start Jenkins with Docker
./scripts/start-ngrok.sh     # Start ngrok tunnel
./scripts/get-ngrok-url.sh   # Get current ngrok URL
./scripts/test-webex.sh      # Test WebEx webhook
./scripts/test-pipeline.sh   # Make test commit
```

## 🐛 Troubleshooting

### Jenkins not starting?
```bash
docker logs -f jenkins-cicd
```

### ngrok not working?
```bash
curl http://127.0.0.1:4040/api/tunnels
```

### Tests failing?
```bash
python3 -m unittest test_app.py -v
```

### Webhook not triggering?
- Verify URL has `/github-webhook/` and trailing slash
- Check ngrok inspector: http://127.0.0.1:4040
- Check GitHub webhook "Recent Deliveries"

## 📖 Learning Outcomes

This project demonstrates:
- Version control with Git/GitHub
- Continuous Integration principles
- Docker containerization
- Webhook integration
- Automated testing
- Pipeline as code
- Team collaboration tools

## 📝 License

This project is for educational purposes as part of a CI/CD course assignment.

## 🙋 Getting Help

1. Check [QUICK_START.md](QUICK_START.md) for common issues
2. Review [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed steps
3. Check individual setup guides in [setup/](setup/) directory
4. Verify all prerequisites are installed
5. Test components individually before full integration

---

**Ready to start?** Follow [QUICK_START.md](QUICK_START.md) to get up and running in 30 minutes! 🚀
