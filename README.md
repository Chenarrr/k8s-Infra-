# Kubernetes Full-Stack Application Deployment

A complete guide to building a production-like 3-node Kubernetes cluster with a full-stack application.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Application Components](#application-components)
6. [Deployment](#deployment)
7. [Access](#access)
8. [Commands Reference](#commands-reference)
9. [Troubleshooting](#troubleshooting)
10. [Next Steps](#next-steps)

---

## Project Overview

**What Was Built:**
- 3-node Kubernetes cluster (1 master, 2 workers)
- Full-stack application: MongoDB + Node.js Backend + React Frontend
- Persistent storage for database
- Multi-tier networking with service discovery

**Technology Stack:**
- Virtualization: Multipass (nested VMs)
- OS: Ubuntu 22.04 LTS
- Kubernetes: v1.28 (kubeadm)
- Container Runtime: containerd
- Network Plugin: Flannel CNI
- Registry: Docker Hub

---

## Architecture

```
Main VM (142.93.28.130) - Ubuntu 22.04, 4 CPUs, 8GB RAM, 120GB Disk
└── Multipass
    ├── k8s-master (10.69.234.135) - Control Plane - 2 CPUs, 2.5GB RAM
    ├── k8s-worker1 (10.69.234.74) - Worker Node - 1 CPU, 2GB RAM
    └── k8s-worker2 (10.69.234.29) - Worker Node - 1 CPU, 2GB RAM
```

**Network Flow:**
```
Browser → SSH Tunnel/NodePort → Frontend (port 80)
                                    ↓
                              Backend Service (port 5000)
                                    ↓
                              MongoDB Service (port 27017)
                                    ↓
                              PersistentVolume (/mnt/data/mongodb)
```

---

## Prerequisites

**Hardware:**
- Main VM: 4+ CPUs, 8GB+ RAM, 60GB+ disk

**Software:**
- Docker Desktop (for building images)
- SSH client
- Terminal access

---

## Installation

### Phase 1: VM Setup

```bash
# Install Multipass
sudo snap install multipass

# Create VMs
multipass launch --name k8s-master --cpus 2 --memory 2.5G --disk 20G 22.04
multipass launch --name k8s-worker1 --cpus 1 --memory 2G --disk 15G 22.04
multipass launch --name k8s-worker2 --cpus 1 --memory 2G --disk 15G 22.04

# Verify
multipass list
```

---

### Phase 2: Kubernetes Installation

**Create installation script:**

```bash
cat > install-k8s.sh << 'EOF'
#!/bin/bash
# Update and disable swap
sudo apt update && sudo apt upgrade -y
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load kernel modules
cat <<MODULES | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
MODULES
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
cat <<SYSCTL | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
SYSCTL
sudo sysctl --system

# Install containerd
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Add Kubernetes repo
sudo apt install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet
EOF

chmod +x install-k8s.sh
```

**Run on all nodes:**

```bash
# Master
multipass transfer install-k8s.sh k8s-master:/home/ubuntu/
multipass exec k8s-master -- bash /home/ubuntu/install-k8s.sh

# Workers
multipass transfer install-k8s.sh k8s-worker1:/home/ubuntu/
multipass exec k8s-worker1 -- bash /home/ubuntu/install-k8s.sh

multipass transfer install-k8s.sh k8s-worker2:/home/ubuntu/
multipass exec k8s-worker2 -- bash /home/ubuntu/install-k8s.sh
```

---

### Phase 3: Cluster Setup

**Initialize master:**

```bash
multipass shell k8s-master

# Initialize (use master's IP)
sudo kubeadm init --apiserver-advertise-address=10.69.234.135 --pod-network-cidr=10.244.0.0/16

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install network plugin
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Verify
kubectl get nodes
```

**Join workers:**

```bash
# Exit master, then join each worker with the command from kubeadm init output
exit

multipass shell k8s-worker1
sudo kubeadm join 10.69.234.135:6443 --token YOUR_TOKEN --discovery-token-ca-cert-hash sha256:YOUR_HASH
exit

multipass shell k8s-worker2
sudo kubeadm join 10.69.234.135:6443 --token YOUR_TOKEN --discovery-token-ca-cert-hash sha256:YOUR_HASH
exit
```

**Verify cluster:**

```bash
multipass shell k8s-master
kubectl get nodes
# All nodes should show "Ready"
```

---

## Application Components

### 1. MongoDB (Database)
- Type: StatefulSet
- Storage: 5Gi PersistentVolume (hostPath)
- Port: 27017
- Service: Headless (ClusterIP: None)

### 2. Backend API
- Type: Deployment
- Image: chenarrr/devops:backend
- Port: 5000
- Environment: MONGODB_URI=mongodb://mongodb-service:27017/notes-app
- Service: ClusterIP

### 3. Frontend
- Type: Deployment
- Image: chenarrr/devops:frontend
- Port: 80
- Service: LoadBalancer (NodePort: 31009)

---`

**Deploy:**
```bash
kubectl apply -f mongodb-storage.yaml
kubectl apply -f mongodb-statefulset.yaml
kubectl apply -f mongodb-service.yaml
```

---
 

**Deploy:**
```bash
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

---

**Deploy:**
```bash
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
```

**Verify all:**
```bash
kubectl get all
```

---

## Access

### Method 1: SSH Tunnel (Recommended)

**From your Mac:**
```bash
ssh -L 8080:10.69.234.135:31009 root@142.93.28.130
```

**Then open browser:**
```
http://localhost:8080
```

### Method 2: Direct NodePort

**Open firewall:**
```bash
sudo ufw allow 31009/tcp
```

**Access from browser:**
```
http://142.93.28.130:31009
```

---

## Commands Reference

### Cluster Management
```bash
kubectl get nodes                    # View nodes
kubectl get pods                     # List pods
kubectl get services                 # List services
kubectl get all                      # View all resources
kubectl describe pod POD_NAME        # Pod details
kubectl logs POD_NAME                # View logs
kubectl logs -f POD_NAME             # Follow logs
kubectl exec -it POD_NAME -- /bin/bash  # Shell into pod
```

### Deployment Management
```bash
kubectl scale deployment NAME --replicas=3      # Scale deployment
kubectl delete pod POD_NAME                     # Delete pod
kubectl delete deployment NAME                  # Delete deployment
kubectl rollout status deployment/NAME          # Check rollout
```

### Storage
```bash
kubectl get pv                       # List persistent volumes
kubectl get pvc                      # List claims
kubectl describe pv PV_NAME          # PV details
```

### Multipass
```bash
multipass list                       # List VMs
multipass shell VM_NAME              # Shell into VM
multipass transfer FILE VM:/path/    # Copy files
multipass start/stop/restart VM      # Manage VM state
```

---

## Troubleshooting

### Pod Pending
```bash
kubectl describe pod POD_NAME
# Check Events section for resource/volume issues
```

### ImagePullBackOff
```bash
kubectl describe pod POD_NAME
# Common: Wrong architecture (arm64 vs amd64)
# Solution: Rebuild image with --platform linux/amd64
docker buildx build --platform linux/amd64 -t IMAGE --push .
```

### CrashLoopBackOff
```bash
kubectl logs POD_NAME
kubectl logs POD_NAME --previous
# Check application errors, environment variables, dependencies
```

### Service Not Accessible
```bash
kubectl get svc                      # Check service
kubectl get endpoints SERVICE_NAME   # Verify endpoints
kubectl get pods                     # Ensure pods running
```

### Worker Not Joining
```bash
# On worker:
sudo systemctl status containerd
sudo systemctl restart containerd

# On master (generate new token):
kubeadm token create --print-join-command
```

---

## Next Steps

### Enhance Setup
- Add Ingress Controller (Nginx)
- Implement health checks (liveness/readiness probes)
- Set up monitoring (Prometheus + Grafana)
- Configure RBAC for security
- Use Secrets for sensitive data
- Implement Network Policies

### Scale Application
```bash
kubectl scale deployment backend --replicas=3
kubectl autoscale deployment backend --cpu-percent=70 --min=2 --max=10
```

### CI/CD
- Deploy ArgoCD for GitOps
- Automate deployments from Git
- Implement rollback strategies

### Learn More
- Service Mesh (Istio)
- Helm Charts
- Kubernetes Operators
- Multi-cluster management
- Try managed Kubernetes (EKS, GKE, AKS, OKE)

---

## Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubeadm Setup Guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Killercoda Labs](https://killercoda.com/)

---

## Project Summary

**Infrastructure:**
- Total VMs: 4 (1 main + 3 Kubernetes)
- Kubernetes Nodes: 3 (1 master + 2 workers)
- Resources: 4 CPUs, 6.5GB RAM (cluster)

**Application:**
- Total Pods: 3-5
- Services: 4
- Persistent Volumes: 1 (5Gi)
- Container Images: 2

**Skills Demonstrated:**
- Kubernetes cluster setup with kubeadm
- Multi-tier application deployment
- Persistent storage management
- Service networking and discovery
- Container orchestration
- Troubleshooting and debugging

---

**Author:** Chenar  
**Date:** February 3, 2026  
**Environment:** Self-hosted datacenter VM  
**Cluster:** 3-node kubeadm with full-stack application