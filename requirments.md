Kubernetes Cluster Setup Guide
Prerequisites

Multipass installed
kubectl installed
Docker Hub account with your images


Part 1: Clean Up (If needed)
bash# Delete existing deployments
kubectl delete deployment --all
kubectl delete svc --all

# Delete VMs
multipass delete k8s-master k8s-worker1 k8s-worker2
multipass purge

# Verify clean state
multipass list

Part 2: Create VMs
bash# Create 3 VMs
multipass launch --name k8s-master --cpus 2 --memory 2G --disk 20G 22.04
multipass launch --name k8s-worker1 --cpus 2 --memory 2G --disk 20G 22.04
multipass launch --name k8s-worker2 --cpus 2 --memory 2G --disk 20G 22.04

# Check VMs are running
multipass list
# Note down the IP addresses

Part 3: Setup Master Node
bash# Disable swap
multipass exec k8s-master -- sudo swapoff -a
multipass exec k8s-master -- sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
multipass exec k8s-master -- sudo modprobe overlay
multipass exec k8s-master -- sudo modprobe br_netfilter

multipass exec k8s-master -- sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Configure sysctl
multipass exec k8s-master -- sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

multipass exec k8s-master -- sudo sysctl --system

# Install containerd
multipass exec k8s-master -- sudo apt-get update
multipass exec k8s-master -- sudo apt-get install -y containerd

# Configure containerd
multipass exec k8s-master -- sudo mkdir -p /etc/containerd
multipass exec k8s-master -- bash -c "containerd config default | sudo tee /etc/containerd/config.toml"
multipass exec k8s-master -- sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

multipass exec k8s-master -- sudo systemctl restart containerd
multipass exec k8s-master -- sudo systemctl enable containerd

# Install Kubernetes packages
multipass exec k8s-master -- sudo apt-get install -y apt-transport-https ca-certificates curl

multipass exec k8s-master -- sudo mkdir -p /etc/apt/keyrings
multipass exec k8s-master -- bash -c "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"

multipass exec k8s-master -- bash -c "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list"

multipass exec k8s-master -- sudo apt-get update
multipass exec k8s-master -- sudo apt-get install -y kubelet kubeadm kubectl
multipass exec k8s-master -- sudo apt-mark hold kubelet kubeadm kubectl

Part 4: Initialize Master
bash# Replace MASTER_IP with your actual master IP from multipass list
multipass exec k8s-master -- sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=MASTER_IP

# Setup kubeconfig
multipass exec k8s-master -- mkdir -p /home/ubuntu/.kube
multipass exec k8s-master -- sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
multipass exec k8s-master -- sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

# Install Flannel CNI
multipass exec k8s-master -- kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Get join command - SAVE THIS OUTPUT!
multipass exec k8s-master -- sudo kubeadm token create --print-join-command

Part 5: Setup Worker Nodes
Worker 1
bash# Disable swap
multipass exec k8s-worker1 -- sudo swapoff -a
multipass exec k8s-worker1 -- sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
multipass exec k8s-worker1 -- sudo modprobe overlay
multipass exec k8s-worker1 -- sudo modprobe br_netfilter

multipass exec k8s-worker1 -- sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Configure sysctl
multipass exec k8s-worker1 -- sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

multipass exec k8s-worker1 -- sudo sysctl --system

# Install containerd
multipass exec k8s-worker1 -- sudo apt-get update
multipass exec k8s-worker1 -- sudo apt-get install -y containerd

# Configure containerd
multipass exec k8s-worker1 -- sudo mkdir -p /etc/containerd
multipass exec k8s-worker1 -- bash -c "containerd config default | sudo tee /etc/containerd/config.toml"
multipass exec k8s-worker1 -- sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

multipass exec k8s-worker1 -- sudo systemctl restart containerd
multipass exec k8s-worker1 -- sudo systemctl enable containerd

# Install Kubernetes packages
multipass exec k8s-worker1 -- sudo apt-get install -y apt-transport-https ca-certificates curl

multipass exec k8s-worker1 -- sudo mkdir -p /etc/apt/keyrings
multipass exec k8s-worker1 -- bash -c "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"

multipass exec k8s-worker1 -- bash -c "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list"

multipass exec k8s-worker1 -- sudo apt-get update
multipass exec k8s-worker1 -- sudo apt-get install -y kubelet kubeadm kubectl
multipass exec k8s-worker1 -- sudo apt-mark hold kubelet kubeadm kubectl

# Join cluster - PASTE YOUR JOIN COMMAND FROM PART 4
multipass exec k8s-worker1 -- sudo kubeadm join MASTER_IP:6443 --token TOKEN --discovery-token-ca-cert-hash sha256:HASH
Worker 2
bash# Disable swap
multipass exec k8s-worker2 -- sudo swapoff -a
multipass exec k8s-worker2 -- sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
multipass exec k8s-worker2 -- sudo modprobe overlay
multipass exec k8s-worker2 -- sudo modprobe br_netfilter

multipass exec k8s-worker2 -- sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Configure sysctl
multipass exec k8s-worker2 -- sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

multipass exec k8s-worker2 -- sudo sysctl --system

# Install containerd
multipass exec k8s-worker2 -- sudo apt-get update
multipass exec k8s-worker2 -- sudo apt-get install -y containerd

# Configure containerd
multipass exec k8s-worker2 -- sudo mkdir -p /etc/containerd
multipass exec k8s-worker2 -- bash -c "containerd config default | sudo tee /etc/containerd/config.toml"
multipass exec k8s-worker2 -- sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

multipass exec k8s-worker2 -- sudo systemctl restart containerd
multipass exec k8s-worker2 -- sudo systemctl enable containerd

# Install Kubernetes packages
multipass exec k8s-worker2 -- sudo apt-get install -y apt-transport-https ca-certificates curl

multipass exec k8s-worker2 -- sudo mkdir -p /etc/apt/keyrings
multipass exec k8s-worker2 -- bash -c "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"

multipass exec k8s-worker2 -- bash -c "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list"

multipass exec k8s-worker2 -- sudo apt-get update
multipass exec k8s-worker2 -- sudo apt-get install -y kubelet kubeadm kubectl
multipass exec k8s-worker2 -- sudo apt-mark hold kubelet kubeadm kubectl

# Join cluster - PASTE YOUR JOIN COMMAND FROM PART 4
multipass exec k8s-worker2 -- sudo kubeadm join MASTER_IP:6443 --token TOKEN --discovery-token-ca-cert-hash sha256:HASH

Part 6: Setup kubectl on Your Mac
bash# Create .kube directory
mkdir -p ~/.kube

# Copy kubeconfig from master
multipass exec k8s-master -- sudo cat /etc/kubernetes/admin.conf > ~/.kube/config

# Fix the server IP (replace MASTER_IP with your actual IP)
sed -i '' 's|server: https://.*:6443|server: https://MASTER_IP:6443|' ~/.kube/config

# Verify cluster
kubectl get nodes

# Wait until all nodes show Ready status
kubectl get nodes -w

Part 7: Deploy Your Application
Create deployment.yaml
yamlapiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: YOUR_DOCKERHUB/backend:latest
        ports:
        - containerPort: 5000
        env:
        - name: MONGO_URL
          value: "mongodb://mongodb-service:27017/mydb"
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 5000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: YOUR_DOCKERHUB/frontend:latest
        ports:
        - containerPort: 3000
        env:
        - name: BACKEND_URL
          value: "http://backend-service:5000"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - protocol: TCP
    port: 3000
    targetPort: 3000
    nodePort: 30080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:7-jammy
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          value: "admin"
        - name: MONGO_INITDB_ROOT_PASSWORD
          value: "password"
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
  - protocol: TCP
    port: 27017
    targetPort: 27017
Deploy
bash# Apply the deployment
kubectl apply -f deployment.yaml

# Check pods
kubectl get pods -o wide

# Check services
kubectl get svc

# Wait for all pods to be Running
kubectl get pods -w

# Check logs
kubectl logs -l app=backend
kubectl logs -l app=frontend
kubectl logs -l app=mongodb

Part 8: Access Your Application
bash# Get the NodePort
kubectl get svc frontend-service

# Access via any node IP on port 30080
# http://MASTER_IP:30080
# http://WORKER1_IP:30080
# http://WORKER2_IP:30080

# Test from command line
curl http://MASTER_IP:30080

Troubleshooting
Check node status
bashkubectl get nodes
kubectl describe node NODE_NAME
Check pod status
bashkubectl get pods -o wide
kubectl describe pod POD_NAME
kubectl logs POD_NAME
Check services
bashkubectl get svc
kubectl describe svc SERVICE_NAME
Restart a deployment
bashkubectl rollout restart deployment DEPLOYMENT_NAME
Delete and recreate
bashkubectl delete -f deployment.yaml
kubectl apply -f deployment.yaml
Reset a worker node
bashmultipass exec WORKER_NAME -- sudo kubeadm reset -f
multipass exec WORKER_NAME -- sudo rm -rf /etc/cni/net.d
multipass exec WORKER_NAME -- sudo systemctl restart containerd

# Get new join command
multipass exec k8s-master -- sudo kubeadm token create --print-join-command

# Rejoin
multipass exec WORKER_NAME -- sudo kubeadm join ...

Cleanup
bash# Delete all deployments
kubectl delete -f deployment.yaml

# Delete VMs
multipass delete k8s-master k8s-worker1 k8s-worker2
multipass purge

Notes

Replace YOUR_DOCKERHUB with your Docker Hub username
Replace MASTER_IP, WORKER1_IP, WORKER2_IP with actual IPs from multipass list
Replace TOKEN and HASH with actual values from the join command
All commands are run from your Mac terminal, not inside VMs
Use multipass exec to run commands on VMs
Wait for pods to be Running before accessing the application
NodePort range is 30000-32767


Quick Reference
bash# Check everything
kubectl get all -o wide

# Get node IPs
multipass list

# Get pod logs
kubectl logs POD_NAME -f

# Scale deployment
kubectl scale deployment DEPLOYMENT_NAME --replicas=N

# Delete pod
kubectl delete pod POD_NAME

# Shell into pod
kubectl exec -it POD_NAME -- /bin/sh