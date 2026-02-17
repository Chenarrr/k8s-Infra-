
# Notes App - DevSecOps with GitOps & Kubernetes

A production-ready full-stack notes application with automated CI/CD, security scanning, and GitOps deployment using Flux CD.

## 🚀 Quick Overview

**What This Is:**
- Production-grade Notes application (React + Node.js + MongoDB)  
- Complete DevSecOps pipeline with security scanning
- GitOps deployment with Flux CD auto-sync
- Kubernetes deployment on DigitalOcean
- Comprehensive Helm chart with 19 automated tests

**Technologies:**
- **Frontend:** React with Nginx
- **Backend:** Node.js/Express API
- **Database:** MongoDB 8 with persistent storage
- **Infrastructure:** Kubernetes + Helm + Flux CD
- **Security:** Trivy scanning, Pod security policies
- **CI/CD:** GitHub Actions with automated image builds

## 📁 Repository Structure

```
k8s-Infra-/
├── charts/notes-app/           # Helm chart for deployment
│   ├── templates/             # Kubernetes manifests
│   ├── values.yaml           # Configuration (111 lines, no comments)
│   ├── tests/                # 19 automated tests
│   └── Makefile              # Development commands
├── app/                      # Flux deployment configs
├── flux-system/              # Auto-generated Flux configs
├── clusters/                 # Flux cluster definitions
└── README.md                # This file
```

## 🔄 How It Works

**Developer Workflow:**
1. Push code to [DevSecOps repo](https://github.com/Chenarrr/DevSecOps)
2. GitHub Actions: lint → build → security scan → push images
3. Actions automatically updates image tags in this repo
4. Flux CD detects changes and deploys to Kubernetes
5. Zero manual deployment steps!

**Infrastructure:**
- **VM1 (142.93.28.130):** Multipass Kubernetes cluster (control-plane + worker)
- **VM2 (159.65.118.205):** Rancher management UI
- **GitOps:** Flux monitors this repo every minute for changes
- **Security:** All images scanned for CRITICAL+HIGH vulnerabilities

## 🧪 Chart Testing & Quality

Your Helm chart includes comprehensive testing infrastructure:

```bash
cd charts/notes-app

# Run all 19 tests
make test

# Lint chart
make lint  

# Generate documentation with Frigate
make docs

# Run everything
make check
```

**Test Coverage:**
- ✅ 6 backend deployment tests
- ✅ 5 frontend deployment tests  
- ✅ 5 MongoDB StatefulSet tests
- ✅ 3 service configuration tests

**Documentation Generator:** 
Using [Frigate v0.7.0](https://frigate.readthedocs.io) to automatically analyze all templates, values, and Chart metadata for comprehensive documentation.

## 📖 Usage & Installation

**Install the chart:**
```bash
helm install notes-app ./charts/notes-app -n notes-app --create-namespace
```

**Or use with Flux (GitOps approach):**
The chart is automatically deployed via Flux CD when changes are pushed to this repository.

**Override values:**
```bash
helm install notes-app ./charts/notes-app \
  --set backend.image.tag=backend-abc123 \
  --set frontend.image.tag=frontend-abc123
```

## 🛠️ Development Commands

```bash
cd charts/notes-app

# Test everything
make check           # Runs: lint + test + docs

# Individual commands
make test           # Run 19 unit tests
make lint           # Validate chart syntax
make docs           # Auto-generate README with Frigate
make clean          # Remove temporary files
```

## 🔧 What Frigate Does For You

**Frigate vs. Previous Tools:**

| Feature | helm-docs | **Frigate** |
|---------|-----------|-------------|
| Analysis Depth | Values.yaml only | **All templates + values + Chart.yaml** |
| Output Quality | Basic table | **Professional documentation** |
| Kubernetes Awareness | None | **Understands actual resources created** |
| Manual Work | Some manual README writing | **Zero manual work - completely automated** |

**Frigate Benefits:**
- ✅ **Deep Analysis** - Reads all your template files, not just values
- ✅ **Kubernetes-Aware** - Understands what resources you're creating
- ✅ **Zero Manual Work** - Completely automated documentation
- ✅ **Production Ready** - Professional documentation format
- ✅ **Template Understanding** - Analyzes your actual Helm templates

**Generated Documentation Includes:**
- Complete parameter table with all 67 configuration options
- Current image tags and versions
- Resource specifications and security settings
- Service configurations and networking
- All automatically updated when you change your chart

---

_This project demonstrates modern DevSecOps practices with GitOps, security scanning, automated testing, and comprehensive documentation generation._
