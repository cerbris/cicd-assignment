# Jenkins Access Information

## 🚀 Access Jenkins Now

### URL
```
http://jenkins.15.204.74.157.nip.io
```

### Initial Admin Password
```
8c019e08475445a68a4bc66abf310a69
```

## Quick Start

1. Open your browser and go to: http://jenkins.15.204.74.157.nip.io
2. Paste the password: `8c019e08475445a68a4bc66abf310a69`
3. Click "Install suggested plugins"
4. Create your admin user
5. Done!

## For GitHub Webhooks

Use this URL for your GitHub webhook configuration:
```
http://jenkins.15.204.74.157.nip.io/github-webhook/
```

**Important**: Include the trailing slash!

## Troubleshooting

If you can't access Jenkins:

### Check pod status:
```bash
kubectl get pods -n cicd-assignment
```

### Check logs:
```bash
kubectl logs -n cicd-assignment deployment/jenkins -f
```

### Check Ingress:
```bash
kubectl get ingress -n cicd-assignment
```

### Use port-forward as alternative:
```bash
kubectl port-forward -n cicd-assignment service/jenkins 8080:8080
```
Then access: http://localhost:8080

## Kubernetes Resources

All resources are in the `cicd-assignment` namespace:
- Pod: jenkins-85546c46dc-2q9w2
- Service: jenkins (NodePort)
- Ingress: jenkins-ingress
- PVC: jenkins-pvc (10Gi)

View all:
```bash
kubectl get all -n cicd-assignment
```
