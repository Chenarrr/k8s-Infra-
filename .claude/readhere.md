# Best Practices: Docker, CI/CD, Kubernetes & ArgoCD

## Docker

- **Never use `latest` tag** — always tag with commit SHA or version number so you know exactly which version is running.
- **Use small base images** — use `node:alpine` instead of `node:latest`. Smaller images mean faster pulls and less attack surface.
- **Use multi-stage builds** — build in one stage, copy only the output to a final slim image. Keeps your production image clean and small.
- **One process per container** — don't put your backend and database in the same container. Each service gets its own container.
- **Use `.dockerignore`** — exclude `node_modules`, `.git`, `*.md`, and anything not needed in the image.
- **Don't run as root** — use `USER node` or a non-root user in your Dockerfile.
- **Order Dockerfile layers wisely** — put things that change less (like `COPY package.json` and `RUN npm install`) before things that change often (like `COPY . .`). This maximizes layer caching.

## GitHub Actions (CI)

- **Never hardcode secrets** — use GitHub Secrets for Docker Hub credentials, tokens, API keys, etc.
- **Tag images with commit SHA** — e.g., `chenarrr/myapp:a1b2c3d` so every build is traceable back to the exact code.
- **Run tests before building** — don't push broken images to Docker Hub. Test first, build second.
- **Separate CI from CD** — CI (GitHub Actions) builds the image. CD (ArgoCD) handles deployment. Don't mix them.
- **Use caching** — cache Docker layers in GitHub Actions to speed up builds.
- **Pin action versions** — use `actions/checkout@v4` not `actions/checkout@latest` to avoid unexpected breaking changes.

## Kubernetes

### Organization

- **Use namespaces** — separate your apps into namespaces (`namespace: app1`, `namespace: app2`). Don't dump everything in `default`.
- **Use labels consistently** — label everything with `app`, `env`, `version` so you can filter and organize resources.
- **Declarative only** — never use `kubectl edit`, `kubectl run`, or `kubectl create` in production. Everything goes through YAML files stored in Git.

### Security

- **Don't run containers as root** — set `runAsNonRoot: true` in your security context.
- **Use ConfigMaps for config** — don't hardcode environment variables in your deployment YAML.
- **Use Secrets for sensitive data** — passwords, API keys, tokens go in Kubernetes Secrets, not in plain YAML.
- **Use RBAC** — define who and what can access your cluster resources. Don't give everything cluster-admin.
- **Use network policies** — restrict which pods can talk to each other.

### Reliability

- **Always set resource requests and limits** — CPU and memory limits so one app can't consume all cluster resources.
- **Use liveness probes** — so Kubernetes can restart your app if it's stuck or crashed.
- **Use readiness probes** — so Kubernetes only sends traffic to pods that are ready to serve.
- **Set pod disruption budgets** — ensure a minimum number of pods stay running during node maintenance.
- **Use multiple replicas** — don't run a single pod in production. Use at least 2 replicas for high availability.

### Deployments

- **Use rolling updates** — the default strategy. Kubernetes replaces pods one by one with zero downtime.
- **Set `maxUnavailable` and `maxSurge`** — control how many pods can be down during a rollout.
- **Never use `latest` image tag** — same as Docker. Use specific tags so rollbacks are predictable.

## ArgoCD (GitOps / CD)

- **Enable auto-sync with self-heal** — if someone manually changes something on the cluster, ArgoCD reverts it back to match Git.
- **One ArgoCD Application per app** — keeps things clean, independent, and easy to debug.
- **Use the App of Apps pattern** — one parent ArgoCD application manages all your child applications. Scales well for multiple projects.
- **Manifests repo separate from code repo** — clean separation of concerns. Code repo handles building, manifests repo handles deploying.
- **Use sync waves and hooks** — control the order of deployment. For example, deploy the database before the backend.
- **Enable pruning** — if you delete a resource from Git, ArgoCD should delete it from the cluster too.

## Overall GitOps Principles

- **Git is the single source of truth** — if it's not in Git, it doesn't exist on the cluster.
- **Never `kubectl apply` manually in production** — let ArgoCD handle all deployments.
- **Everything is versioned** — you can rollback to any previous state by reverting a Git commit.
- **Audit trail built-in** — every change is a Git commit with a timestamp and author. You always know who changed what and when.
- **Pull over push** — let ArgoCD (inside the cluster) pull changes rather than giving external CI tools direct cluster access.

## The Ideal Flow

```
1. Developer pushes code to the code repo
2. GitHub Actions runs tests
3. GitHub Actions builds Docker image (tagged with commit SHA)
4. GitHub Actions pushes image to Docker Hub
5. GitHub Actions updates the image tag in the manifests repo
6. ArgoCD detects the change in the manifests repo
7. ArgoCD syncs the cluster to match the manifests repo
8. Kubernetes pulls the new image from Docker Hub
9. App is updated with zero downtime
```