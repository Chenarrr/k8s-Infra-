# Kubernetes Full-Stack Deployment with Flux CD (GitOps)

## Infrastructure Overview

```
Your Laptop
    | git push (DevSecOps repo)
GitHub Actions
    | builds image, updates image tag in k8s-Infra-
GitHub (k8s-Infra- repo)
    | Flux detects change (every 1 min)
DigitalOcean VM1 (142.93.28.130)
    +-- Multipass
        +-- cp-1 (Control Plane)  <- Flux runs here
        +-- worker-1 (Worker Node) <- App runs here

DigitalOcean VM2 (159.65.118.205)
    +-- Rancher Server (Docker)   <- Web UI to manage cluster
            | imported/manages
        notes-cluster (cp-1 + worker-1)
```

---

## What's Running

| Component | Namespace | Purpose |
|-----------|-----------|---------|
| Frontend (React + Nginx) | notes-app | User interface (port 80) |
| Backend (Express.js) | notes-app | API server (port 5000) |
| MongoDB 8 (StatefulSet) | notes-app | Database (port 27017) |
| NGINX Ingress | ingress-nginx | Routes external traffic |
| Flannel | kube-flannel | Pod networking (CNI) |
| Flux CD | flux-system | GitOps auto-deployment |
| Rancher | cattle-system | Web UI cluster management |

---

## Repo Structure (k8s-Infra-)

```
k8s-Infra-/
+-- app/                              <- Flux watches this folder
|   +-- namespace.yaml                <- notes-app namespace
|   +-- notes-app-helmrelease.yaml    <- Flux HelmRelease (deploys the chart)
|   +-- kustomization.yaml            <- Lists resources for Flux
+-- charts/
|   +-- notes-app/                    <- Helm chart
|       +-- Chart.yaml                <- Chart metadata (v0.1.0)
|       +-- values.yaml               <- All configuration values
|       +-- templates/
|           +-- _helpers.tpl          <- Template helpers
|           +-- backend.yaml          <- Backend Deployment + Service
|           +-- frontend.yaml         <- Frontend Deployment + Service
|           +-- mongodb.yaml          <- MongoDB StatefulSet + PV/PVC + Service
|           +-- ingress.yaml          <- NGINX Ingress
+-- clusters/
|   +-- notes-app.yaml               <- Flux Kustomization pointing to ./app
+-- flux-system/
|   +-- flux-system/
|       +-- gotk-components.yaml      <- Flux controllers (auto-generated, don't edit)
|       +-- gotk-sync.yaml           <- Flux Git sync config (auto-generated)
|       +-- kustomization.yaml       <- (auto-generated, don't edit)
+-- README.md
```

---

## Helm Chart Configuration

The app is deployed via a Helm chart at `charts/notes-app/` using a single `values.yaml`.

### Key Values

| Setting | Value |
|---------|-------|
| Backend image | `chenarrr/devops:backend-<sha>` |
| Frontend image | `chenarrr/devops:frontend-<sha>` |
| MongoDB image | `mongo:8` |
| Backend CPU | 100m-200m | 50m-100m |
| Backend memory | 128Mi-256Mi | 64Mi-128Mi |
| Frontend CPU | 100m-200m | 50m-100m |
| Frontend memory | 128Mi-256Mi | 64Mi-128Mi |
| MongoDB CPU | 250m-500m | 100m-250m |
| MongoDB memory | 256Mi-512Mi | 128Mi-256Mi |
| NODE_ENV | production | development |

### Security Context (Backend)

- `runAsNonRoot: true`, `runAsUser: 1000`
- `allowPrivilegeEscalation: false`

### Health Checks

| Component | Readiness | Liveness |
|-----------|-----------|----------|
| Backend | `GET /api/notes` (5s delay) | `GET /api/notes` (15s delay) |
| Frontend | `GET /` (5s delay) | `GET /` (10s delay) |
| MongoDB | `mongosh --eval db.adminCommand('ping')` (10s delay) | same (30s delay) |

---

## How GitOps Works (Flux CD)

```
1. You edit code on laptop (DevSecOps repo)
        |
2. git push to GitHub
        |
3. GitHub Actions builds new Docker image -> Docker Hub
        |
4. GitHub Actions runs Trivy security scan (CRITICAL + HIGH)
        |
5. GitHub Actions updates image tags in charts/notes-app/values.yaml
        |
6. Flux detects new commit in k8s-Infra- (every 1 min)
        |
7. Flux reads clusters/notes-app.yaml -> watches ./app folder
        |
8. Flux applies HelmRelease -> Helm renders templates with values
        |
9. Kubernetes rolling update -> new pods with new image
```

**You only push code. Everything else is automatic!**

---

## STATIC - Copy Paste Exactly (Never Changes)

### Step 1: Fix DNS on VM1 (Run Once After Fresh Droplet)

```bash
# On VM1 (DigitalOcean)
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
sudo tee /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
```

### Step 2: Create VMs

```bash
multipass launch --name cp-1 --cpus 2 --memory 2.5G --disk 20G 22.04
multipass launch --name worker-1 --cpus 2 --memory 2G --disk 20G 22.04
```

### Step 3: Setup cp-1

```bash
multipass shell cp-1

# Fix DNS
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/dns.conf <<EOF
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1
EOF
sudo systemctl restart systemd-resolved

# Install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg containerd

# Add Kubernetes repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes tools
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

# Disable swap
sudo swapoff -a

# Init cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(hostname -I | awk '{print $1}')

# Setup kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel CNI
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

### Step 4: Setup worker-1

```bash
multipass shell worker-1

# Fix DNS
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/dns.conf <<EOF
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1
EOF
sudo systemctl restart systemd-resolved

# Install same packages as cp-1 (repeat apt-get install steps)
# Then run the join command (see DYNAMIC section)
```

### Step 5: Install Ingress Controller

```bash
# On cp-1
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml
```

### Step 6: Fix CoreDNS

```bash
kubectl get configmap coredns -n kube-system -o yaml | \
  sed 's|forward . /etc/resolv.conf|forward . 8.8.8.8 8.8.4.4|g' | \
  kubectl apply -f -

kubectl delete pods -n kube-system -l k8s-app=kube-dns
```

### Step 7: Install Flux CD

```bash
# On cp-1 - Install Flux CLI
curl -LO https://github.com/fluxcd/flux2/releases/download/v2.2.3/flux_2.2.3_linux_amd64.tar.gz
tar -xzf flux_2.2.3_linux_amd64.tar.gz
sudo mv flux /usr/local/bin/

# Create GitHub token at: https://github.com/settings/tokens
# Scopes needed: repo, admin:repo_hook
export GITHUB_TOKEN=your_github_token_here

# Bootstrap Flux - installs Flux AND commits its config to k8s-Infra- repo
flux bootstrap github \
  --owner=Chenarrr \
  --repository=k8s-Infra- \
  --branch=main \
  --path=flux-system \
  --personal

# Verify
flux get all
kubectl get pods -n flux-system
```

### Step 8: Deploy App via Flux

Flux automatically deploys the app using the HelmRelease in `app/notes-app-helmrelease.yaml`. After bootstrapping Flux, apply the cluster kustomization:

```bash
# On cp-1
kubectl apply -f ~/k8s-Infra-/clusters/notes-app.yaml

# Verify Flux picked it up
flux get kustomizations
flux get helmreleases -A
```

Both should show `True` and `Applied revision`.

---

## DYNAMIC - Check Every Time After Restart

### Get cp-1 IP

```bash
multipass list
```

### Get Worker Join Command

```bash
# On cp-1
kubeadm token create --print-join-command
```

### Get Ingress NodePort

```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
# Look for 80:XXXXX/TCP
```

### Start Port Forwarding (After Every VM1 Restart)

```bash
# On VM1 - replace XXXXX with NodePort, CP1_IP with cp-1 IP
sudo socat TCP-LISTEN:XXXXX,bind=0.0.0.0,fork,reuseaddr TCP:<CP1_IP>:XXXXX &
sudo ufw allow XXXXX/tcp
```

**App URL:** `http://142.93.28.130:XXXXX`

---

## After Every Restart Checklist

```bash
# 1. Check VMs running
multipass list

# 2. Shell into cp-1
multipass shell cp-1

# 3. Check cluster and app
kubectl get nodes
kubectl get pods -n notes-app
kubectl get pods -n flux-system

# 4. Check Flux HelmRelease
flux get helmreleases -A

# 5. Get NodePort
kubectl get svc -n ingress-nginx ingress-nginx-controller

# 6. Exit and start socat on VM1
exit
sudo socat TCP-LISTEN:XXXXX,bind=0.0.0.0,fork,reuseaddr TCP:<CP1_IP>:XXXXX &

# 7. Check Flux is syncing
multipass shell cp-1
flux get kustomizations
```

---

## Daily Flux Commands

```bash
# Check what commit Flux has pulled
flux get source git

# Check if Flux applied changes
flux get kustomizations

# Check HelmRelease status
flux get helmreleases -A

# Force sync NOW (don't wait 1 min)
flux reconcile source git flux-system
flux reconcile kustomization notes-app --with-source

# Watch deploy in real time
flux get kustomizations -w

# Check Flux logs
flux logs --all-namespaces

# Check all Flux resources
flux get all

# Check what image pods are running
kubectl get pods -n notes-app -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```

---

## Useful kubectl Commands

```bash
# Check everything
kubectl get pods -A

# Check app pods
kubectl get pods -n notes-app

# Check pod logs
kubectl logs -n notes-app <pod-name>

# Restart a deployment
kubectl rollout restart deployment backend -n notes-app
kubectl rollout restart deployment frontend -n notes-app

# Check node resources
kubectl describe node worker-1 | grep -A 10 "Allocated resources"

# Check Helm release values
helm get values notes-app -n notes-app
```

---

## How to Deploy New Code

```bash
# 1. Edit code in DevSecOps repo
# 2. git push

# GitHub Actions automatically:
#   -> Lints and builds frontend/backend
#   -> Builds Docker images and pushes to Docker Hub
#   -> Runs Trivy security scan (CRITICAL + HIGH)
#   -> Updates image tags in charts/notes-app/values.yaml

# Flux automatically within 1 min:
#   -> Detects new commit in k8s-Infra-
#   -> Reconciles HelmRelease
#   -> Helm renders templates with new image tags
#   -> Rolling update, zero downtime

# Verify new image is running:
kubectl get pods -n notes-app -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```

---

## Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n notes-app
kubectl logs <pod-name> -n notes-app
```

### Flux not syncing
```bash
flux logs
flux reconcile source git flux-system
flux reconcile kustomization notes-app --with-source
```

### HelmRelease failing
```bash
flux get helmreleases -A
kubectl describe helmrelease notes-app -n flux-system
```

### Flux SSH key error (after rebuilding cluster)
Happens when you rebuild cluster but old deploy key is still on GitHub.
```bash
# 1. Go to: https://github.com/Chenarrr/k8s-Infra-/settings/keys
# 2. Delete key named: flux-system-main-flux-system-./flux-system
# 3. Remove old flux-system folder from repo
cd k8s-Infra-
rm -rf flux-system
git add .
git commit -m "Remove old Flux config"
git push

# 4. Re-bootstrap
export GITHUB_TOKEN=your_token_here
flux bootstrap github \
  --owner=Chenarrr \
  --repository=k8s-Infra- \
  --branch=main \
  --path=flux-system \
  --personal

# 5. Re-apply notes-app kustomization
kubectl apply -f ~/k8s-Infra-/clusters/notes-app.yaml
```

### Flux kustomization conflict error
```bash
kubectl delete kustomization notes-app -n flux-system
kubectl apply -f ~/k8s-Infra-/clusters/notes-app.yaml
flux reconcile kustomization notes-app --with-source
```

### Pods stuck in Pending (Insufficient CPU)
```bash
kubectl delete pods --all -n notes-app
kubectl get pods -n notes-app -w
```

### Rolling Update Issue (CPU Constraint)

**Symptom:** After deployments, old and new pods both run and old ones don't terminate.

**Why:** Worker-1 has limited CPU. Rolling updates try to start new pods before stopping old ones -> not enough CPU -> deadlock.

**Fix (After Every Deployment):**
```bash
kubectl delete pods --all -n notes-app
kubectl get pods -n notes-app -w
```

### DNS issues on cp-1
```bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### Can't access app from browser
```bash
# Check socat is running on VM1
ps aux | grep socat

# Get NodePort
kubectl get svc -n ingress-nginx ingress-nginx-controller

# Restart socat
sudo pkill socat
sudo socat TCP-LISTEN:XXXXX,bind=0.0.0.0,fork,reuseaddr TCP:<CP1_IP>:XXXXX &
```

### Cluster not responding
```bash
sudo systemctl restart kubelet
sudo systemctl restart containerd
```

---

## Infrastructure Info

| Component | Value |
|-----------|-------|
| VM1 IP | 142.93.28.130 |
| cp-1 IP | `multipass list` |
| worker-1 IP | `multipass list` |
| Kubernetes Version | v1.28 |
| CNI | Flannel |
| GitOps Tool | Flux CD v2.2.3 |
| App Namespace | notes-app |
| Ingress Namespace | ingress-nginx |
| Flux Namespace | flux-system |
| App Repo | https://github.com/Chenarrr/DevSecOps |
| Infra Repo | https://github.com/Chenarrr/k8s-Infra- |
| Docker Hub | chenarrr/devops |
| Rancher URL | https://159.65.118.205 |
| Rancher User | admin |
| Rancher Cluster | notes-cluster |

---

## Rancher Setup (Cluster Web UI)

Rancher is a web dashboard running on VM2 that lets you manage your Kubernetes cluster visually instead of using kubectl commands.

**Access:** `https://159.65.118.205`
**Username:** `admin`
**Password:** `LjZG1mP3KmvyhAq6`

### How Rancher Connects to Your Cluster

```
VM2 (Rancher Server)
    | Rancher agent installed on cluster
cp-1 (Kubernetes Control Plane)
    +-- Rancher agent runs here, reports back to VM2
```

### Step 9: Install Rancher on VM2

```bash
# On VM2 (159.65.118.205)

# Install Docker
curl -fsSL https://get.docker.com | sh

# Run Rancher
docker run -d \
  --restart=unless-stopped \
  -p 80:80 \
  -p 443:443 \
  --privileged \
  rancher/rancher:latest
```

Wait 2-3 minutes then open `https://159.65.118.205` in browser.

Get bootstrap password:
```bash
docker logs $(docker ps -q) 2>&1 | grep "Bootstrap Password:"
```

### Step 10: Import Your Cluster into Rancher

1. Open `https://159.65.118.205`
2. Login with bootstrap password
3. Set new password and confirm Server URL
4. Click **Import Existing** on the home screen
5. Give cluster name: `notes-cluster`
6. Click **Create**
7. Copy the `curl --insecure` command shown on screen
8. Run it on cp-1:

```bash
# On cp-1 - paste the command from Rancher UI
curl --insecure -sfL https://159.65.118.205/v3/import/<unique-token>.yaml | kubectl apply -f -
```

9. Wait 1-2 minutes and refresh Rancher - cluster shows **Active**

### What You Can Do in Rancher

- **Workloads** -> see all pods, deployments, restart them
- **Services** -> see all services and ports
- **Config** -> view ConfigMaps and Secrets
- **Namespaces** -> switch between notes-app, flux-system, ingress-nginx
- **Logs** -> click any pod -> view logs without kubectl
- **Shell** -> exec into any pod from browser
- **Events** -> see what's happening in real time

### Rancher Troubleshooting

#### Cluster stuck in Provisioning
```bash
# On cp-1 - check if Rancher agent is running
kubectl get pods -n cattle-system
```

#### Can't reach Rancher UI
```bash
# On VM2 - check Docker is running
docker ps
docker logs $(docker ps -q) | tail -20
```

#### Re-import cluster after rebuild
```bash
# In Rancher UI: delete old cluster -> Import Existing -> new name
# Run new curl command on cp-1
```
