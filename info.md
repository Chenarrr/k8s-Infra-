# DevSecOps Full-Stack Deployment — GitOps with Flux CD

A production-grade Kubernetes deployment pipeline with security scanning, GitOps automation, and infrastructure-as-code. Code pushed to the [DevSecOps](https://github.com/Chenarrr/DevSecOps) repo triggers a fully automated pipeline: lint, build, scan, deploy — zero manual intervention.

> **📅 Documentation Status:** Updated February 17, 2026 - All configurations and values match current codebase
>
> **🔥 Latest Features:**
> - ✅ 19 automated Helm chart tests covering all components
> - ✅ GitHub Actions CI/CD pipeline with quality gates  
> - ✅ Auto-generated documentation with Frigate
> - ✅ Production-ready chart repository

---

## ✅ Project Status & Verification  

**Current Working Configuration (Verified February 17, 2026):**

| Component | Status | Current Version |
|-----------|---------|-----------------|
| **Backend Image** | ✅ Active | `chenarrr/devops:backend-8193810` |
| **Frontend Image** | ✅ Active | `chenarrr/devops:frontend-8193810` | 
| **MongoDB** | ✅ Active | `mongo:8` |
| **Helm Chart** | ✅ Tested | `v0.1.0` with 19 passing tests |
| **CI/CD Pipeline** | ✅ Active | GitHub Actions + helm-test.yaml |
| **Documentation** | ✅ Current | Auto-generated with Frigate |

**Verified Components:**
- ✅ All template files exist: `_helpers.tpl`, `backend.yaml`, `frontend.yaml`, `mongodb.yaml`, `ingress.yaml` 
- ✅ Test suites complete: 4 test files covering all components (19 tests total)
- ✅ Values.yaml configuration matches deployment settings
- ✅ Makefile provides development workflow commands
- ✅ GitHub Actions workflow configured for chart testing
- ✅ Flux GitOps deployment configuration ready

---

## Architecture

```
Developer Laptop
    | git push (DevSecOps repo)
GitHub Actions (CI/CD Pipeline)
    | lint -> build -> Trivy scan -> push image -> update k8s-Infra-
GitHub (k8s-Infra- repo)
    | Flux detects change (every 1 min)
DigitalOcean VM1 (142.93.28.130)
    +-- Multipass
        +-- cp-1 (Control Plane)   <- Flux runs here
        +-- worker-1 (Worker Node) <- App runs here

DigitalOcean VM2 (159.65.118.205)
    +-- Rancher Server (Docker)    <- Web UI to manage cluster
            | imported/manages
        notes-cluster (cp-1 + worker-1)
```

---

## 🚀 Quick Start & Validation

**Test Your Helm Chart (Right Now!):**
```bash
# Install helm unittest plugin (one-time setup)
helm plugin install https://github.com/helm-unittest/helm-unittest --verify=false

# Run all tests to verify everything works
make test

# Expected output:
# 🧪 Running tests...
# Charts:      1 passed, 1 total
# Test Suites: 4 passed, 4 total  
# Tests:       19 passed, 19 total ✅

# Lint the chart
make lint

# Generate fresh documentation (creates README.md at project root)
make docs

# Run complete validation
make check
```

**Deploy with Current Images:**
The chart is ready to deploy with the current image tags:
- Backend: `backend-8193810` 
- Frontend: `frontend-8193810`

---

## DevSecOps Pipeline

```
Code Push
  |
  v
GitHub Actions
  |-- Lint (ESLint, code quality)
  |-- Build (frontend + backend Docker images)
  |-- Security Scan (Trivy: CRITICAL + HIGH CVEs)
  |-- Push to Docker Hub (chenarrr/devops)
  |-- Update image tags in k8s-Infra-/charts/notes-app/values.yaml
  |
  v
Flux CD (GitOps)
  |-- Detects new commit in k8s-Infra- (1 min interval)
  |-- Reconciles HelmRelease
  |-- Helm renders templates with new image tags
  |-- Kubernetes rolling update (zero downtime)
```

### Security Measures

| Layer | Tool/Practice |
|-------|--------------|
| Container scanning | Trivy (CRITICAL + HIGH severity) |
| Pod security | `runAsNonRoot: true`, `runAsUser: 1000` |
| Privilege escalation | `allowPrivilegeEscalation: false` |
| Resource limits | CPU/memory limits on all containers |
| Health checks | Readiness + liveness probes on all components |
| GitOps | No direct cluster access needed — all changes via Git |
| Helm labels | Standard `app.kubernetes.io/*` labels for observability |

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

## Helm Chart Testing Infrastructure 🧪

This project includes a comprehensive testing infrastructure for the Helm chart to ensure quality and prevent deployment issues.

### 🛠️ What We Built

**Testing Stack:**
- **Helm Unittest** - Unit testing for Helm templates
- **Helm Lint** - Chart validation and best practices
- **Frigate** - Advanced chart documentation generator (creates root README.md)
- **GitHub Actions** - Automated testing on every push/PR
- **Root Makefile** - Unified development commands from project root

### 📁 Testing Structure

```
k8s-Infra-/
├── Makefile                    # Root development commands
├── README.md                   # Auto-generated by Frigate
├── charts/notes-app/
│   ├── tests/                  # Test suites (19 tests total)
│   │   ├── backend-deployment_test.yaml     # 6 tests for backend
│   │   ├── frontend-deployment_test.yaml    # 5 tests for frontend
│   │   ├── mongodb-statefulset_test.yaml    # 5 tests for MongoDB
│   │   └── services_test.yaml              # 3 tests for all services
│   └── templates/              # Helm templates
└── .github/workflows/
    └── helm-test.yaml          # CI/CD pipeline for chart testing
```

### 🧪 What Gets Tested

**Template Validation:**
- ✅ Correct Kubernetes resource types (Deployment, Service, StatefulSet)
- ✅ Resource naming patterns
- ✅ Environment variables and configuration
- ✅ Health checks (readiness/liveness probes)
- ✅ Resource limits and security contexts
- ✅ Service types and port configurations
- ✅ MongoDB StatefulSet with persistent volumes
- ✅ Helm template helper functions

**Quality Checks:**
- ✅ Helm chart lint validation
- ✅ YAML syntax correctness
- ✅ Best practices compliance
- ✅ Template rendering without errors

### 🚀 How to Use

**Prerequisites (one-time setup):**
```bash
# Install Helm unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest --verify=false

# Install Frigate documentation generator
pip3 install frigate
```

**All commands run from project root:**
```bash
make test    # Run all chart tests
make lint    # Lint chart for best practices
make docs    # Generate README.md with chart documentation
make check   # Run all validation checks
```

**Development Commands (all from project root):**
```bash
# Show all available commands  
make help

# Run all tests (19 tests across 4 suites)
make test

# Lint the chart
make lint

# Generate documentation
make docs

# Run complete validation
make check
```

# Generate documentation
make docs

# Run everything (lint + test + docs)
make check

# Clean up generated files
make clean
```

**Available Commands (from Makefile):**
- `make test` - Run Helm unit tests
- `make lint` - Lint Helm chart 
- `make docs` - Generate README documentation
- `make check` - Run all checks (lint + test + docs)
- `make clean` - Clean up .tgz files

**📝 Clean Configuration Approach:**

✅ **Minimal values.yaml** - Clean configuration without documentation comments  
✅ **Essential values only** - Just the parameters you need to configure  
✅ **Easy to read** - Simple, straightforward YAML structure  
✅ **Auto-generated docs** - Comprehensive documentation via Frigate  
✅ **Faster maintenance** - No metadata comments to maintain

Focuses on simplicity and clean configuration files while still providing automated documentation generation.

### 🔥 **Advanced Documentation with Frigate**

**What is Frigate?**
Frigate is an advanced Helm chart documentation generator that provides enterprise-grade automated documentation. Unlike basic tools that only read values.yaml, Frigate analyzes your entire chart structure.

**How Frigate Works:**
- 🔍 **Deep Analysis** - Reads all template files, values.yaml, and Chart.yaml
- 🧠 **Kubernetes-Aware** - Understands what Kubernetes resources you're creating
- 🏗️ **Template Processing** - Uses Jinja2 templates for professional output
- ⚡ **Zero Manual Work** - Completely automated documentation generation

**Frigate vs. Other Tools:**

| Feature | Basic Tools | **Frigate** |
|---------|-------------|-------------|
| Analysis Depth | Values only | **All templates + values + charts** |
| Output Quality | Basic table | **Professional documentation** |
| Kubernetes Understanding | None | **Resource-aware analysis** |
| Manual Work Required | Some writing needed | **Zero manual documentation** |
| Template Customization | Limited | **Full Jinja2 customization** |

**What Frigate Generates for Your Chart:**
- Complete parameter table (all 67 configuration options)
- Current image tags and versions (backend-8193810, frontend-8193810)  
- Resource specifications and security settings
- Service configurations and networking details
- Professional formatting with proper descriptions

### 📊 Test Results Example

```bash
$ make test
🧪 Running tests...

### Chart [ notes-app ] .

 PASS  test backend deployment  tests/backend-deployment_test.yaml
 PASS  test frontend deployment tests/frontend-deployment_test.yaml
 PASS  test mongodb statefulset tests/mongodb-statefulset_test.yaml
 PASS  test services    tests/services_test.yaml

Charts:      1 passed, 1 total
Test Suites: 4 passed, 4 total
Tests:       19 passed, 19 total ✅
```

### 🤖 Continuous Integration

**GitHub Actions Pipeline:**
- **Triggers:** Push to main, PRs affecting `charts/**`
- **Steps:**
  1. Checkout code
  2. Setup Helm v4.1.1
  3. Install helm-unittest plugin
  4. Lint chart (`helm lint`)
  5. Run tests (`helm unittest`)
  6. Install Frigate  
  7. Generate documentation (`frigate gen`)

**Benefits:**
- 🛡️ **Quality Gate** - Prevents broken charts from being deployed
- 🚀 **Fast Feedback** - Know immediately if changes break anything
- 📚 **Auto Documentation** - Chart README updates automatically
- 🔄 **Consistent Testing** - Same tests run locally and in CI
- 🧹 **Clean Configuration** - Simple values.yaml without excessive comments

### 🎯 Why This Matters

**Before Testing Infrastructure:**
- ❌ Manual chart validation
- ❌ Deployment failures discovered late
- ❌ No guarantee templates render correctly
- ❌ Manual documentation maintenance

**After Testing Infrastructure:**
- ✅ **Automated validation** of all chart changes
- ✅ **19 tests** covering critical functionality
- ✅ **Catch issues early** before they reach production
- ✅ **Confidence in deployments** through comprehensive testing
- ✅ **Documentation always up-to-date**

This testing infrastructure ensures that every change to the Helm chart is validated, tested, and documented automatically — maintaining the same high standards as the application code itself.

---

## Repo Structure

```
k8s-Infra-/
+-- .github/workflows/
|   +-- helm-test.yaml               <- CI/CD pipeline for Helm chart testing
+-- app/
|   +-- namespace.yaml                <- notes-app namespace
|   +-- notes-app-helmrelease.yaml    <- Flux HelmRelease (deploys the chart)
|   +-- kustomization.yaml            <- Lists resources for Flux
+-- charts/
|   +-- notes-app/                    <- Helm chart (best-practice structure)
|       +-- Chart.yaml                <- Chart metadata (v0.1.0)
|       +-- values.yaml               <- Single source of truth for all config
|       +-- Makefile                  <- Development commands (lint/test/docs)
|       +-- templates/
|       |   +-- _helpers.tpl          <- Standard label/selector helpers
|       |   +-- backend.yaml          <- Backend Deployment + Service
|       |   +-- frontend.yaml         <- Frontend Deployment + Service
|       |   +-- mongodb.yaml          <- MongoDB StatefulSet + PV/PVC + Service
|       |   +-- ingress.yaml          <- NGINX Ingress
|       +-- tests/                    <- Helm chart test suites (19 tests)
|           +-- backend-deployment_test.yaml    <- 6 tests for backend
|           +-- frontend-deployment_test.yaml   <- 5 tests for frontend
|           +-- mongodb-statefulset_test.yaml   <- 5 tests for MongoDB
|           +-- services_test.yaml             <- 3 tests for services
+-- clusters/
|   +-- notes-app.yaml               <- Flux Kustomization pointing to ./app
+-- flux-system/                      <- Auto-generated by Flux (don't edit)
+-- README.md
```

---

## Helm Chart — Deep Dive

The entire application is packaged as a single Helm chart at `charts/notes-app/`. Flux deploys it via a HelmRelease resource.

### Chart Metadata (`Chart.yaml`)

```yaml
apiVersion: v2
name: notes-app
description: Full stack notes app chart managed by Flux
type: application
version: 0.1.0          # Chart version (bump when changing templates)
appVersion: "1.0.0"     # App version (shown in labels)
```

### How Flux Deploys the Chart

Flux uses the HelmRelease in `app/notes-app-helmrelease.yaml`:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta2
kind: HelmRelease
metadata:
  name: notes-app
  namespace: flux-system
spec:
  interval: 1m                    # Check for changes every minute
  releaseName: notes-app
  targetNamespace: notes-app      # Deploy into notes-app namespace
  timeout: 5m
  install:
    remediation:
      retries: 3                  # Retry 3 times on failed install
  upgrade:
    cleanupOnFail: true           # Clean up failed upgrades
    remediation:
      retries: 3
  chart:
    spec:
      chart: ./charts/notes-app   # Path to chart in repo
      sourceRef:
        kind: GitRepository
        name: flux-system
      reconcileStrategy: Revision  # Re-deploy on any new commit
      valuesFiles:
        - ./charts/notes-app/values.yaml   # Single values file
```

**Flow:** Flux detects new commit -> reads HelmRelease -> renders chart with `values.yaml` -> applies to cluster.

### Template Helpers (`_helpers.tpl`)

All labels are auto-generated using named templates instead of being hardcoded. This follows the `helm create` standard.

**Base helpers:**

| Template | Output | Purpose |
|----------|--------|---------|
| `notes-app.name` | `notes-app` | Chart name (truncated to 63 chars) |
| `notes-app.fullname` | `notes-app` | Full name (uses `fullnameOverride` from values) |
| `notes-app.chart` | `notes-app-0.1.0` | Chart name + version for tracking |

**Label helpers:**

| Template | What it generates |
|----------|-------------------|
| `notes-app.labels` | Common labels on every resource (chart, managed-by, instance, version, part-of) |
| `notes-app.backend.labels` | Common labels + `name: backend` + `component: api` |
| `notes-app.backend.selectorLabels` | Just `name: backend` (used in matchLabels + service selectors) |
| `notes-app.frontend.labels` | Common labels + `name: frontend` + `component: web` |
| `notes-app.frontend.selectorLabels` | Just `name: frontend` |
| `notes-app.mongodb.labels` | Common labels + `name: mongodb` + `component: database` |
| `notes-app.mongodb.selectorLabels` | Just `name: mongodb` |
| `notes-app.ingress.labels` | Common labels only (no component) |

**How templates use them:**

```yaml
# In backend.yaml — labels use include + nindent
metadata:
  name: {{ .Values.backend.name }}
  labels:
    {{- include "notes-app.backend.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "notes-app.backend.selectorLabels" . | nindent 6 }}
```

**Rendered output (what Kubernetes sees):**

```yaml
metadata:
  name: backend
  labels:
    helm.sh/chart: notes-app-0.1.0
    app.kubernetes.io/part-of: notes-app
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/instance: notes-app
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/name: backend
    app.kubernetes.io/component: api
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: backend
```

### What Each Template Creates

| Template File | Kubernetes Resources | Condition |
|---------------|---------------------|-----------|
| `backend.yaml` | Deployment + Service (ClusterIP:5000) | `backend.enabled: true` |
| `frontend.yaml` | Deployment + Service (ClusterIP:80) | `frontend.enabled: true` |
| `mongodb.yaml` | PersistentVolume + PVC + headless Service + StatefulSet | `mongodb.enabled: true` |
| `ingress.yaml` | Ingress (NGINX class, routes `/` to frontend) | `ingress.enabled: true` |

### Template Best Practices Used

| Practice | How |
|----------|-----|
| `nindent` over `indent` | All `toYaml` and `include` calls use `nindent` — safer, handles newlines automatically |
| Labels via `include` | No hardcoded labels in `values.yaml` — all generated by `_helpers.tpl` |
| Selector labels separated | `selectorLabels` is a subset of `labels` — selectors are immutable after creation |
| Conditional rendering | `{{- if .Values.X.enabled }}` wraps each template — disable any component from values |
| Single values file | One `values.yaml` — no environment-specific overrides, simpler to manage |
| Standard Kubernetes labels | `app.kubernetes.io/*` labels on every resource for observability tools |

### Values Reference (`values.yaml`)

Single file, every value is used in templates. Nothing is unused.

**Images:**

| Component | Repository | Tag Pattern |
|-----------|-----------|-------------|
| Backend | `chenarrr/devops` | `backend-<git-sha>` |
| Frontend | `chenarrr/devops` | `frontend-<git-sha>` |
| MongoDB | `mongo` | `8` |

Image tags are updated automatically by GitHub Actions on every push to the DevSecOps repo.
**Current image tags:**
- Backend: `backend-8193810`
- Frontend: `frontend-8193810`
**Resources (requests / limits):**

| Component | CPU | Memory |
|-----------|-----|--------|
| Backend | 100m / 200m | 128Mi / 256Mi |
| Frontend | 50m / 100m | 64Mi / 128Mi |
| MongoDB | 100m / 200m | 256Mi / 512Mi |

**Security Context:**

| Setting | Backend | Frontend |
|---------|---------|----------|
| runAsNonRoot | true | — |
| runAsUser | 1000 | — |
| fsGroup | 1000 | — |
| allowPrivilegeEscalation | false | false |
| readOnlyRootFilesystem | false | — |

**Health Checks:**

| Component | Readiness | Liveness |
|-----------|-----------|----------|
| Backend | `GET /api/notes` (30s delay, 10s interval) | `GET /api/notes` (120s delay, 60s interval) |
| Frontend | `GET /` (5s delay, 10s interval) | `GET /` (30s delay, 60s interval) |
| MongoDB | `mongosh db.adminCommand('ping')` (30s delay) | same (120s delay) |

**MongoDB Storage:**

```yaml
storage:
  storageClassName: manual      # Uses hostPath PV (single-node setup)
  size: 5Gi
  hostPath: /mnt/data/mongodb   # Data persists on worker node disk
```

**Ingress:**

```yaml
ingress:
  className: nginx              # NGINX Ingress Controller
  path: /                       # Routes all traffic to frontend
  pathType: Prefix
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
```

### How to Override Values

For manual Helm installs (without Flux):

```bash
# Install with defaults
helm install notes-app ./charts/notes-app -n notes-app

# Override specific values
helm install notes-app ./charts/notes-app -n notes-app \
  --set backend.image.tag=backend-abc123 \
  --set frontend.image.tag=frontend-abc123

# Disable a component
helm install notes-app ./charts/notes-app -n notes-app \
  --set mongodb.enabled=false
```

With Flux, just edit `values.yaml` and push — Flux handles the rest.

---

## How to Deploy New Code

```bash
# 1. Edit code in DevSecOps repo
# 2. git push — that's it!

# GitHub Actions automatically:
#   -> Lints and builds frontend/backend
#   -> Builds Docker images and pushes to Docker Hub
#   -> Runs Trivy security scan (CRITICAL + HIGH)
#   -> Updates image tags in charts/notes-app/values.yaml

# Flux automatically within 1 min:
#   -> Detects new commit in k8s-Infra-
#   -> Reconciles HelmRelease
#   -> Rolling update with zero downtime

# Verify:
kubectl get pods -n notes-app -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
```

---

## Setup Guide

### STATIC — Run Once

#### Step 1: Fix DNS on VM1

```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
sudo tee /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
```

#### Step 2: Create VMs

```bash
multipass launch --name cp-1 --cpus 2 --memory 2.5G --disk 20G 22.04
multipass launch --name worker-1 --cpus 2 --memory 2G --disk 20G 22.04
```

#### Step 3: Setup cp-1

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

#### Step 4: Setup worker-1

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

#### Step 5: Install Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml
```

#### Step 6: Fix CoreDNS

```bash
kubectl get configmap coredns -n kube-system -o yaml | \
  sed 's|forward . /etc/resolv.conf|forward . 8.8.8.8 8.8.4.4|g' | \
  kubectl apply -f -

kubectl delete pods -n kube-system -l k8s-app=kube-dns
```

#### Step 7: Install Flux CD

```bash
curl -LO https://github.com/fluxcd/flux2/releases/download/v2.2.3/flux_2.2.3_linux_amd64.tar.gz
tar -xzf flux_2.2.3_linux_amd64.tar.gz
sudo mv flux /usr/local/bin/

export GITHUB_TOKEN=your_github_token_here

flux bootstrap github \
  --owner=Chenarrr \
  --repository=k8s-Infra- \
  --branch=main \
  --path=flux-system \
  --personal

flux get all
kubectl get pods -n flux-system
```

#### Step 8: Deploy App via Flux

```bash
kubectl apply -f ~/k8s-Infra-/clusters/notes-app.yaml

flux get kustomizations
flux get helmreleases -A
```

Both should show `True` and `Applied revision`.

#### Step 9: Install Rancher on VM2

```bash
curl -fsSL https://get.docker.com | sh

docker run -d \
  --restart=unless-stopped \
  -p 80:80 \
  -p 443:443 \
  --privileged \
  rancher/rancher:latest
```

Wait 2-3 minutes then open `https://159.65.118.205`.

```bash
docker logs $(docker ps -q) 2>&1 | grep "Bootstrap Password:"
```

#### Step 10: Import Cluster into Rancher

1. Open `https://159.65.118.205`
2. Login with bootstrap password, set new password
3. Click **Import Existing** -> name: `notes-cluster` -> **Create**
4. Copy the `curl --insecure` command and run on cp-1:

```bash
curl --insecure -sfL https://159.65.118.205/v3/import/<unique-token>.yaml | kubectl apply -f -
```

Wait 1-2 minutes — cluster shows **Active**.

---

### DYNAMIC — Check After Every Restart

```bash
# 1. Check VMs
multipass list

# 2. Shell into cp-1
multipass shell cp-1

# 3. Check cluster
kubectl get nodes
kubectl get pods -n notes-app
kubectl get pods -n flux-system
flux get helmreleases -A

# 4. Get NodePort
kubectl get svc -n ingress-nginx ingress-nginx-controller
# Look for 80:XXXXX/TCP

# 5. Exit and start socat on VM1
exit
sudo socat TCP-LISTEN:XXXXX,bind=0.0.0.0,fork,reuseaddr TCP:<CP1_IP>:XXXXX &
sudo ufw allow XXXXX/tcp
```

**App URL:** `http://142.93.28.130:XXXXX`

---

## Flux Commands

```bash
flux get source git              # What commit Flux has pulled
flux get kustomizations          # Has Flux applied changes
flux get helmreleases -A         # HelmRelease status
flux get all                     # All Flux resources

# Force sync
flux reconcile source git flux-system
flux reconcile kustomization notes-app --with-source

# Watch and debug
flux get kustomizations -w
flux logs --all-namespaces
```

---

## kubectl Commands

```bash
kubectl get pods -A                                          # All pods
kubectl get pods -n notes-app                                # App pods
kubectl logs -n notes-app <pod-name>                         # Pod logs
kubectl rollout restart deployment backend -n notes-app      # Restart
kubectl describe node worker-1 | grep -A 10 "Allocated"     # Node resources
helm get values notes-app -n notes-app                       # Helm values
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
```bash
# 1. Delete key at: https://github.com/Chenarrr/k8s-Infra-/settings/keys
# 2. Remove old flux config
cd k8s-Infra- && rm -rf flux-system
git add . && git commit -m "Remove old Flux config" && git push

# 3. Re-bootstrap
export GITHUB_TOKEN=your_token_here
flux bootstrap github \
  --owner=Chenarrr \
  --repository=k8s-Infra- \
  --branch=main \
  --path=flux-system \
  --personal

# 4. Re-apply
kubectl apply -f ~/k8s-Infra-/clusters/notes-app.yaml
```

### Rolling update stuck (CPU constraint)
```bash
# Worker-1 has limited CPU — old + new pods can deadlock
kubectl delete pods --all -n notes-app
kubectl get pods -n notes-app -w
```

### Can't access app from browser
```bash
ps aux | grep socat
kubectl get svc -n ingress-nginx ingress-nginx-controller
sudo pkill socat
sudo socat TCP-LISTEN:XXXXX,bind=0.0.0.0,fork,reuseaddr TCP:<CP1_IP>:XXXXX &
```

### Cluster not responding
```bash
sudo systemctl restart kubelet
sudo systemctl restart containerd
```

---

## Infrastructure

| Component | Value |
|-----------|-------|
| VM1 IP | 142.93.28.130 |
| VM2 IP (Rancher) | 159.65.118.205 |
| Kubernetes | v1.28 |
| CNI | Flannel |
| GitOps | Flux CD v2.2.3 |
| Rancher | latest |
| App Namespace | notes-app |
| App Repo | https://github.com/Chenarrr/DevSecOps |
| Infra Repo | https://github.com/Chenarrr/k8s-Infra- |
| Docker Hub | chenarrr/devops |

---

## 🎯 Recent Development Work (February 2026)

### 📋 What We Accomplished

This section documents the comprehensive Helm chart testing infrastructure and tooling improvements implemented to ensure production-ready deployments.

### 🧪 Complete Testing Infrastructure

**Built from scratch:**
- **19 unit tests** across 4 test suites covering all components
- **Automated CI/CD pipeline** with GitHub Actions
- **Documentation generation** that auto-updates from Chart.yaml and values.yaml
- **Development workflow** with Makefile shortcuts
- **Latest 2025-2026 tooling** for cutting-edge capabilities

### 🛠️ Technical Implementation

**Tools & Versions:**
- **Helm v4.1.1** (latest February 2026 release)
- **helm-unittest v1.0.3** (latest October 2025 release)  
- **Frigate v0.7.0** (advanced Helm chart documentation generator)
- **actions/checkout@v6** (latest 2026 GitHub Actions)

**Testing Coverage:**
```
Backend Deployment Tests (6 tests):
✅ Deployment resource creation
✅ Correct naming conventions
✅ Health check probes (liveness/readiness)
✅ Resource limits enforcement
✅ Environment variables (MongoDB URI)
✅ Security context validation

Frontend Deployment Tests (5 tests):
✅ Service configuration
✅ Port mappings (80)
✅ Resource constraints
✅ Health endpoints
✅ Container specifications

MongoDB StatefulSet Tests (5 tests):
✅ Persistent storage
✅ StatefulSet properties
✅ Database connectivity
✅ Volume mounts
✅ Service bindings

Services Tests (3 tests):
✅ ClusterIP configurations
✅ Port definitions
✅ Headless service (MongoDB)
```

### 🚀 Development Workflow

**Makefile Commands:**
```bash
make help     # Show all commands
make test     # Run 19 unit tests (helm unittest)
make lint     # Validate chart syntax (helm lint)
make docs     # Generate README.md (Frigate)
make check    # Full pipeline: lint + test + docs
make clean    # Remove temporary files
```

**GitHub Actions Pipeline:**
- **Triggers:** Push to main, PR changes in charts/
- **Steps:** Checkout → Install Helm → Install plugins → Lint → Test → Generate docs
- **Result:** 100% automated quality gates

### 📚 Documentation System

**Auto-Generated README:**
- **Source:** Chart.yaml + values.yaml
- **Output:** Comprehensive README.md with badges, values table
- **Process:** Completely overwrites file each time
- **Benefit:** Always up-to-date, never outdated

**Key Features:**
- Version badges (Chart v0.1.0, App v1.0.0)
- Full configuration table (92 lines of documentation)
- Auto-sync with actual chart values
- No manual maintenance required

### 🌟 Public Chart Repository

**ArtifactHub Integration:**
- **Repository URL:** https://chenarrr.github.io/k8s-Infra-/
- **Chart Package:** notes-app-0.1.0.tgz
- **Index File:** index.yaml (Helm repository format)
- **Discovery:** Public searchable on ArtifactHub

**Installation for Users:**
```bash
helm repo add chenar https://chenarrr.github.io/k8s-Infra-/
helm repo update
helm install my-notes chenar/notes-app
```

### 🔄 CI/CD Evolution

**Before:**
- Manual testing
- No quality gates
- Documentation drift
- Development friction

**After:**
- 19 automated tests
- Zero-failure deployments
- Self-updating docs
- 1-command workflows

### 🎯 Quality Metrics

**Test Results:**
```
Charts:      1 passed, 1 total
Test Suites: 4 passed, 4 total  
Tests:       19 passed, 19 total
Time:        ~20ms (blazing fast)
```

**Success Rate:** 100% ✅
**Coverage:** All components (backend, frontend, MongoDB, services)
**Automation:** Full pipeline runs on every code change

### 💡 Learning Outcomes

**Helm Templating Mastery:**
- Template syntax (dots, pipes, quotes, includes)
- Values inheritance and override patterns
- Template execution flow and debugging
- Best practices for production charts

**Testing Philosophy:**
- Template rendering validation
- Configuration verification
- Security settings enforcement
- Service discovery validation

**Documentation Strategy:**
- Single source of truth (Chart.yaml/values.yaml)
- Automated generation prevents drift
- Version-controlled and git-tracked
- Public repository ready

### 🏆 Production Benefits

**For Developers:**
- Catch errors before deployment
- Fast feedback loop (20ms test runs)
- Self-documenting infrastructure
- Standardized workflows

**For Operations:**
- Quality gates prevent bad deployments
- Automated testing in CI/CD
- Version-controlled chart releases
- Public discoverability

**For Users:**
- Professional chart repository
- Standard installation process
- Up-to-date documentation
- Trusted, tested releases

This infrastructure ensures that every chart deployment is tested, validated, and documented - providing production-grade reliability for the GitOps workflow.
