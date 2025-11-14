# Kubernetes Deployment - CI/CD Platform

## Deployment Summary

Your Jenkins CI/CD platform has been successfully deployed to Kubernetes!

### Namespace
- **Namespace**: `cicd-assignment`

### Resources Created

1. **PersistentVolumeClaim**: `jenkins-pvc`
   - Storage: 10Gi
   - Access Mode: ReadWriteOnce
   - Storage Class: csi-cinder-high-speed

2. **Deployment**: `jenkins`
   - Image: jenkins/jenkins:lts
   - Replicas: 1
   - Resources:
     - CPU Request: 250m
     - Memory Request: 512Mi
     - CPU Limit: 500m
     - Memory Limit: 1Gi

3. **Service**: `jenkins`
   - Type: NodePort
   - Port 8080 (HTTP) -> NodePort 30080
   - Port 50000 (Agent) -> NodePort 30427

4. **Ingress**: `jenkins-ingress`
   - Hostname: jenkins.15.204.74.157.nip.io
   - LoadBalancer IP: 15.204.74.157

## Access Information

### Jenkins Initial Admin Password
```
8c019e08475445a68a4bc66abf310a69
```

### Access URLs

**✅ Primary Access (via Ingress):**
- **Jenkins UI**: http://jenkins.15.204.74.157.nip.io
- This is the recommended way to access Jenkins
- Use this URL for GitHub webhooks

**Alternative: Port Forwarding (for local access):**
```bash
kubectl port-forward -n cicd-assignment service/jenkins 8080:8080
```
Then access: http://localhost:8080

### Initial Setup Steps

1. **Access Jenkins** at http://jenkins.15.204.74.157.nip.io
2. **Enter the initial admin password**: `8c019e08475445a68a4bc66abf310a69`
3. Click **"Install suggested plugins"**
4. Create your admin user
5. Start using Jenkins!

## Install Python in Jenkins

After initial setup, you'll need to install Python for running your tests:

```bash
# Get the pod name
kubectl get pods -n cicd-assignment

# Execute into the pod
kubectl exec -it -n cicd-assignment jenkins-85546c46dc-2q9w2 -c jenkins -- bash

# Install Python (inside the container)
apt-get update && apt-get install -y python3 python3-pip
python3 --version
exit
```

## Useful Commands

### View all resources
```bash
kubectl get all -n cicd-assignment
```

### View Jenkins logs
```bash
kubectl logs -n cicd-assignment deployment/jenkins -f
```

### Get Jenkins pod name
```bash
kubectl get pods -n cicd-assignment
```

### Execute into Jenkins pod
```bash
kubectl exec -it -n cicd-assignment <pod-name> -c jenkins -- bash
```

### Restart Jenkins
```bash
kubectl rollout restart deployment/jenkins -n cicd-assignment
```

### Delete all resources (cleanup)
```bash
kubectl delete namespace cicd-assignment
```

## Next Steps for Your Assignment

Now that Jenkins is running in Kubernetes, you can proceed with your CI/CD assignment:

1. **Set up GitHub Repository**
   - Push your code to GitHub
   - Configure webhook

2. **Configure Jenkins**
   - Create pipeline job
   - Configure GitHub integration
   - Add WebEx credentials

3. **Set up ngrok**
   - You'll need to expose your Jenkins instance for GitHub webhooks
   - Option 1: Use ngrok to tunnel to NodePort (15.204.77.158:30080)
   - Option 2: Use Kubernetes Ingress with a LoadBalancer

4. **Configure WebEx Bot**
   - Create WebEx incoming webhook
   - Add to Jenkins credentials

5. **Test the Pipeline**
   - Make a code commit
   - Verify GitHub -> Jenkins -> WebEx flow

## Notes

- The Jenkins data is persisted in a PersistentVolume, so your configuration survives pod restarts
- Jenkins is exposed via Ingress at http://jenkins.15.204.74.157.nip.io
- The ingress controller provides external access on LoadBalancer IP 15.204.74.157
- For production use, consider adding TLS/SSL certificates

## Manifest Files

All Kubernetes manifests are stored in the `k8s/` directory:
- [k8s/jenkins-pvc.yaml](k8s/jenkins-pvc.yaml)
- [k8s/jenkins-deployment.yaml](k8s/jenkins-deployment.yaml)
- [k8s/jenkins-service.yaml](k8s/jenkins-service.yaml)
- [k8s/jenkins-ingress.yaml](k8s/jenkins-ingress.yaml)
