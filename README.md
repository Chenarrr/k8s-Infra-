# K8s Notes App Infrastructure

3-tier app: **Frontend** -> **Backend** -> **MongoDB**

| File | Description |
|------|-------------|
| `frontend-deployment.yaml` | Frontend Deployment (1 replica, port 80) |
| `frontend-service.yaml` | LoadBalancer service exposing frontend externally |
| `backend-deployment.yaml` | Backend Deployment (1 replica, port 5000) |
| `backend-service.yaml` | ClusterIP service for internal backend access |
| `mongodb-deployment.yaml` | MongoDB StatefulSet + PersistentVolume (1Gi) |
| `mongodb-service.yaml` | Headless service for MongoDB |

## Cluster Setup
- Master node: 2.5GB RAM minimum

## Deploy
```bash
kubectl apply -f .
```

## Scale
```bash
kubectl scale deployment frontend backend --replicas=2
```
