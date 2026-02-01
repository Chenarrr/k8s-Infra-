PROJECT: Kubernetes Frontend Deployment
========================================

OBJECTIVE:
Deploy the frontend application (chenarrr/devops:frontend) to a local Minikube Kubernetes cluster using YAML manifest files.

REQUIREMENTS:
=============

1. DEPLOYMENT CONFIGURATION
   - Name: frontend
   - Image: chenarrr/devops:frontend
   - Replicas: 3
   - Container Port: 80
   - Resource Limits:
     * Memory: 256Mi
     * CPU: 200m
   - Resource Requests:
     * Memory: 128Mi
     * CPU: 100m
   - Labels: app=frontend

2. SERVICE CONFIGURATION
   - Name: frontend-service
   - Type: NodePort
   - Port: 80
   - TargetPort: 80
   - NodePort: 30080
   - Selector: app=frontend

3. FILE STRUCTURE
   /k8s-frontend/
   ├── deployment.yaml
   ├── service.yaml
   └── README.md (optional)

4. DEPLOYMENT STEPS
   - Apply deployment.yaml first
   - Apply service.yaml second
   - Verify pods are running
   - Access via: minikube service frontend-service --url

5. VERIFICATION COMMANDS
   - kubectl get deployments
   - kubectl get pods
   - kubectl get services
   - kubectl get pods -o wide

6. ENVIRONMENT
   - Platform: Minikube (local Kubernetes)
   - Nodes: 3
   - Kubernetes Version: Latest stable
   - Container Runtime: Docker

7. ADDITIONAL FEATURES (Optional)
   - Health checks (liveness/readiness probes)
   - Rolling update strategy
   - Pod anti-affinity for high availability
   - ConfigMap for environment variables
   - Horizontal Pod Autoscaler

8. SUCCESS CRITERIA
   - 3 pods running successfully
   - Service accessible via NodePort
   - Pods distributed across nodes
   - No CrashLoopBackOff or ImagePullBackOff errors
   - Application responds on port 80

NOTES:
======
- Image source: Docker Hub (chenarrr/devops:frontend)
- Assume image runs on port 80 by default
- Use standard Kubernetes best practices
- Include proper labels and selectors
- Make files production-ready

DELIVERABLES:
=============
1. deployment.yaml - Full deployment manifest
2. service.yaml - Service manifest with NodePort
3. (Optional) README.md with deployment instructions