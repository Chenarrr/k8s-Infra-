# Helm Unit Tests - notes-app

## Overview

This chart uses [helm-unittest](https://github.com/helm-unittest/helm-unittest) to validate all rendered Kubernetes manifests before deployment. Tests are YAML-based and live in the `tests/` directory.

## Running Tests

```bash
helm unittest charts/notes-app
```

## Test Suites

### backend-deployment_test.yaml (25 tests)

Covers the backend `Deployment` resource rendered from `backend.yaml`.

| Category | What's Tested |
|---|---|
| Rendering | Deployment kind, apps/v1 API version, disabled toggle produces 0 documents |
| Metadata | Correct name (`backend`), standard Helm labels, component label (`api`) |
| Replicas | Defaults to 1, override via `backend.replicaCount` |
| Selectors | `spec.selector.matchLabels` matches `spec.template.metadata.labels` |
| Image | Correct repository:tag, pullPolicy, tag override |
| Container Port | Exposes port 5000 |
| Env Vars | `MONGODB_URI` and `NODE_ENV` set correctly, MONGODB_URI override |
| Init Container | `wait-for-mongodb` uses `busybox:1.36` |
| Readiness Probe | HTTP GET `/api/notes` on port 5000, correct timing values |
| Liveness Probe | HTTP GET `/api/notes` on port 5000, correct timing values |
| Pod Security | `runAsNonRoot: true`, `runAsUser: 1000`, `fsGroup: 1000` |
| Container Security | `allowPrivilegeEscalation: false` |
| Resources | Requests (64Mi/10m), limits (256Mi/200m), override support |
| Node Selector | Worker node selector, override, null removal |

---

### frontend-deployment_test.yaml (21 tests)

Covers the frontend `Deployment` resource rendered from `frontend.yaml`.

| Category | What's Tested |
|---|---|
| Rendering | Deployment kind, apps/v1 API version, disabled toggle produces 0 documents |
| Metadata | Correct name (`frontend`), standard Helm labels, component label (`web`) |
| Replicas | Defaults to 1, override via `frontend.replicaCount` |
| Selectors | `spec.selector.matchLabels` matches `spec.template.metadata.labels` |
| Image | Correct repository:tag, pullPolicy, tag override |
| Container Port | Exposes port 80 |
| Readiness Probe | HTTP GET `/` on port 80, correct timing values |
| Liveness Probe | HTTP GET `/` on port 80, correct timing values |
| Container Security | `allowPrivilegeEscalation: false` |
| Resources | Requests (64Mi/50m), limits (128Mi/100m), override support |
| Node Selector | Worker node selector, override, null removal |

---

### mongodb-statefulset_test.yaml (19 tests)

Covers the MongoDB `StatefulSet` resource rendered from `mongodb.yaml` (document index 3).

| Category | What's Tested |
|---|---|
| Rendering | StatefulSet kind, apps/v1 API version, disabled toggle, 4 total documents |
| Metadata | Correct name (`mongodb`), standard Helm labels, component label (`database`) |
| ServiceName | References `mongodb-service` for headless DNS |
| Replicas | Defaults to 1 |
| Selectors | `spec.selector.matchLabels` matches `spec.template.metadata.labels` |
| Image | Correct `mongo:8` image, tag override |
| Container Port | Exposes port 27017 with name `mongodb` |
| Volumes | Mounts `mongodb-storage` at `/data/db`, references `mongodb-pvc` |
| Readiness Probe | Exec probe using `mongosh`, correct timing values |
| Liveness Probe | Exec probe using `mongosh`, correct timing values |
| Resources | Requests (256Mi/50m), limits (512Mi/200m) |
| Node Selector | Worker node selector, null removal |

---

### mongodb-storage_test.yaml (16 tests)

Covers `PersistentVolume` (document index 0) and `PersistentVolumeClaim` (document index 1) from `mongodb.yaml`.

| Category | What's Tested |
|---|---|
| PV Rendering | PersistentVolume kind, v1 API version |
| PV Config | Name `mongodb-pv`, `storageClassName: manual`, capacity 5Gi, `ReadWriteOnce`, hostPath at `/mnt/data/mongodb` with `DirectoryOrCreate` |
| PV Labels | Standard Helm labels, component label (`database`) |
| PV Overrides | Storage size override, hostPath override |
| PVC Rendering | PersistentVolumeClaim kind, v1 API version |
| PVC Config | Name `mongodb-pvc`, matching storageClassName, 5Gi request, `ReadWriteOnce` |
| PVC Labels | Standard Helm labels, component label (`database`) |
| PVC Overrides | Storage size override matches PV |
| Disabled | No documents rendered when `mongodb.enabled: false` |

---

### services_test.yaml (19 tests)

Covers all three `Service` resources across templates.

| Category | What's Tested |
|---|---|
| Backend Service | ClusterIP type, name `backend`, labels (component: api), port 5000 -> 5000, selector matches pod labels, disabled toggle |
| Frontend Service | ClusterIP type, name `frontend`, labels (component: web), port 80 -> 80, selector matches pod labels, disabled toggle |
| MongoDB Service | Headless (`clusterIP: None`), name `mongodb-service`, labels (component: database), port 27017 with name, selector matches pod labels, service name override |

---

### ingress_test.yaml (10 tests)

Covers the `Ingress` resource rendered from `ingress.yaml`.

| Category | What's Tested |
|---|---|
| Rendering | Ingress kind, networking.k8s.io/v1 API version, disabled toggle |
| Metadata | Name `notes-app-ingress`, standard Helm labels |
| Annotations | `nginx.ingress.kubernetes.io/proxy-body-size: 10m` |
| Ingress Class | Defaults to `nginx`, override support |
| Routing | Root path `/` with `Prefix` type routes to `frontend` service on port 80 |
| Overrides | Frontend port override reflected in ingress backend, path/pathType override |

---

## Production Safety Checks

These tests guard against common production issues:

- **Enabled/disabled toggles** - Components produce 0 documents when disabled, preventing resource leaks
- **Selector-label consistency** - `matchLabels` matches pod template labels (mismatches cause orphaned pods)
- **Security contexts** - `runAsNonRoot`, `allowPrivilegeEscalation: false` enforced
- **Resource limits and requests** - Prevents noisy-neighbor and OOMKill scenarios
- **Probe configuration** - Exact paths, ports, and timing validated (bad probes cause crash loops)
- **Value overrides** - Confirms the chart is parameterized, not hardcoded
- **Storage consistency** - PV and PVC use matching storageClassName and size

## Total: 6 suites, 107 tests
