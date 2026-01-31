# Objective


Create a fully automated local Kubernetes cluster using:
- Multipass as the VM provider (manual or shell script)
- Ansible for configuration management
- kubeadm for Kubernetes bootstrap

Cluster topology:
- 1 control-plane (master)
- 2 worker nodes

The setup must be reproducible, idempotent, and CLI-driven.

---

## Prerequisites (Host Machine)
- Multipass installed and working
- Terraform installed
- Ansible installed
- kubectl installed
- SSH key-based authentication configured
- Internet access from VMs
- Docker image already published on Docker Hub

---

## Architecture Overview
- Three Ubuntu VMs created via Multipass
- All nodes on the same private subnet
- Kubernetes version: stable (>= v1.28)
- Container runtime: containerd
- Pod network CIDR: 10.244.0.0/16
- CNI plugin: Flannel

---



## Step 1: Multipass VM Provisioning (Manual)

### Responsibilities
You must:
- Create three Multipass VMs:
  - k8s-master
  - k8s-worker1
  - k8s-worker2
- Assign CPU, memory, disk
- Ensure SSH access
- Output:
  - IP addresses
  - SSH usernames
  - Node roles

Do NOT:
- Install Kubernetes
- Install container runtime
- Configure the OS

### Example Commands
You can use the following commands manually or in a shell script:
```sh
multipass launch --name k8s-master --cpus=2 --mem=2G --disk=20G ubuntu-lts
multipass launch --name k8s-worker1 --cpus=2 --mem=2G --disk=20G ubuntu-lts
multipass launch --name k8s-worker2 --cpus=2 --mem=2G --disk=20G ubuntu-lts
multipass list
```

---

## Step 2: Ansible — Node Configuration

### Inventory
- Inventory generated from Terraform outputs
- Groups:
  - masters
  - workers
  - all

### Common Role (ALL NODES)
- Disable swap
- Load kernel modules (overlay, br_netfilter)
- Configure sysctl for Kubernetes
- Install containerd
- Install kubeadm, kubelet, kubectl
- Enable and start services

### Master Role
- Run kubeadm init with:
  --pod-network-cidr=10.244.0.0/16
- Configure kubectl for the admin user
- Install Flannel CNI
- Extract kubeadm join command

### Worker Role
- Execute kubeadm join using token from master

### Expected Files
- ansible.cfg
- inventory/
- roles/common/
- roles/master/
- roles/worker/
- site.yml

---

## Step 3: Kubernetes Validation

### Required Checks
- kubectl get nodes → all nodes Ready
- kubectl get pods -A → system pods Running
- Pod-to-Pod networking functional
- CoreDNS healthy

---

## Step 4: Application Deployment

### Application Source
- Docker image hosted on Docker Hub
- Image is public and pullable

### Kubernetes Manifests
- Deployment:
  - replicas: 2
  - image: chenarrr/devops:tagname
- Service:
  - type: NodePort
  - exposes application externally

### Validation
- Pods scheduled across worker nodes
- Application reachable via:
  http://<node-ip>:<nodeport>

---

## Success Criteria
- Cluster can be destroyed and recreated
- No manual SSH steps
- No Docker Compose usage
- Clear separation of responsibilities:
  - Terraform → infrastructure
  - Ansible → configuration
  - kubeadm → cluster bootstrap
  - kubectl → operations

---

## Cleanup
- terraform destroy
- kubeadm reset (if needed)
