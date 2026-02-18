# notes-app

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Full stack notes app chart managed by Flux

## Parameters

### Common parameters

| Name               | Description                     | Value       |
| ------------------ | ------------------------------- | ----------- |
| `nameOverride`     | Override the chart name.        | `""`        |
| `fullnameOverride` | Override the full release name. | `notes-app` |

### Backend parameters

| Name                                               | Description                            | Value                                                 |
| -------------------------------------------------- | -------------------------------------- | ----------------------------------------------------- |
| `backend.enabled`                                  | Enable backend deployment.             | `true`                                                |
| `backend.name`                                     | Backend component name.                | `backend`                                             |
| `backend.replicaCount`                             | Number of backend replicas.            | `1`                                                   |
| `backend.image.repository`                         | Image repository.                      | `chenarrr/devops`                                     |
| `backend.image.tag`                                | Image tag.                             | `backend-a725016`                                     |
| `backend.image.pullPolicy`                         | Image pull policy.                     | `Always`                                              |
| `backend.containerPort`                            | Backend container port.                | `5000`                                                |
| `backend.service`                                  | Backend service configuration.         |                                                       |
| `backend.service.type`                             | Service type.                          | `ClusterIP`                                           |
| `backend.service.port`                             | Service port.                          | `5000`                                                |
| `backend.env.mongodbUri`                           | MongoDB connection URI.                | `mongodb://mongodb-0.mongodb-service:27017/notes-app` |
| `backend.env.nodeEnv`                              | Node environment.                      | `production`                                          |
| `backend.podSecurityContext.runAsNonRoot`          | Run as non-root user.                  | `true`                                                |
| `backend.podSecurityContext.runAsUser`             | User ID for the container process.     | `1000`                                                |
| `backend.podSecurityContext.fsGroup`               | File system group ID.                  | `1000`                                                |
| `backend.securityContext.allowPrivilegeEscalation` | Allow privilege escalation.            | `false`                                               |
| `backend.securityContext.readOnlyRootFilesystem`   | Mount root filesystem as read-only.    | `false`                                               |
| `backend.resources.requests.memory`                | Requested memory.                      | `128Mi`                                               |
| `backend.resources.requests.cpu`                   | Requested CPU.                         | `100m`                                                |
| `backend.resources.limits`                         | Backend resource limits.               |                                                       |
| `backend.resources.limits.memory`                  | Memory limit.                          | `256Mi`                                               |
| `backend.resources.limits.cpu`                     | CPU limit.                             | `200m`                                                |
| `backend.readinessProbe.path`                      | Readiness endpoint path.               | `/api/notes`                                          |
| `backend.readinessProbe.initialDelaySeconds`       | Initial delay before readiness checks. | `30`                                                  |
| `backend.readinessProbe.periodSeconds`             | Readiness check interval.              | `10`                                                  |
| `backend.readinessProbe.timeoutSeconds`            | Readiness check timeout.               | `10`                                                  |
| `backend.livenessProbe.path`                       | Liveness endpoint path.                | `/api/notes`                                          |
| `backend.livenessProbe.initialDelaySeconds`        | Initial delay before liveness checks.  | `120`                                                 |
| `backend.livenessProbe.periodSeconds`              | Liveness check interval.               | `60`                                                  |
| `backend.livenessProbe.timeoutSeconds`             | Liveness check timeout.                | `30`                                                  |

### Frontend parameters

| Name                                                | Description                            | Value              |
| --------------------------------------------------- | -------------------------------------- | ------------------ |
| `frontend.enabled`                                  | Enable frontend deployment.            | `true`             |
| `frontend.name`                                     | Frontend component name.               | `frontend`         |
| `frontend.replicaCount`                             | Number of frontend replicas.           | `1`                |
| `frontend.image`                                    | Frontend container image settings.     |                    |
| `frontend.image.repository`                         | Image repository.                      | `chenarrr/devops`  |
| `frontend.image.tag`                                | Image tag.                             | `frontend-a725016` |
| `frontend.image.pullPolicy`                         | Image pull policy.                     | `Always`           |
| `frontend.containerPort`                            | Frontend container port.               | `80`               |
| `frontend.service`                                  | Frontend service configuration.        |                    |
| `frontend.service.type`                             | Service type.                          | `ClusterIP`        |
| `frontend.service.port`                             | Service port.                          | `80`               |
| `frontend.resources`                                | Frontend resource requests and limits. |                    |
| `frontend.resources.requests`                       | Frontend resource requests.            |                    |
| `frontend.resources.requests.memory`                | Requested memory.                      | `64Mi`             |
| `frontend.resources.requests.cpu`                   | Requested CPU.                         | `50m`              |
| `frontend.resources.limits`                         | Frontend resource limits.              |                    |
| `frontend.resources.limits.memory`                  | Memory limit.                          | `128Mi`            |
| `frontend.resources.limits.cpu`                     | CPU limit.                             | `100m`             |
| `frontend.securityContext`                          | Container-level security context.      |                    |
| `frontend.securityContext.allowPrivilegeEscalation` | Allow privilege escalation.            | `false`            |
| `frontend.readinessProbe`                           | Frontend readiness probe settings.     |                    |
| `frontend.readinessProbe.path`                      | Readiness endpoint path.               | `/`                |
| `frontend.readinessProbe.initialDelaySeconds`       | Initial delay before readiness checks. | `5`                |
| `frontend.readinessProbe.periodSeconds`             | Readiness check interval.              | `10`               |
| `frontend.readinessProbe.timeoutSeconds`            | Readiness check timeout.               | `3`                |
| `frontend.livenessProbe`                            | Frontend liveness probe settings.      |                    |
| `frontend.livenessProbe.path`                       | Liveness endpoint path.                | `/`                |
| `frontend.livenessProbe.initialDelaySeconds`        | Initial delay before liveness checks.  | `30`               |
| `frontend.livenessProbe.periodSeconds`              | Liveness check interval.               | `60`               |
| `frontend.livenessProbe.timeoutSeconds`             | Liveness check timeout.                | `10`               |

### MongoDB parameters

| Name                                         | Description                                | Value               |
| -------------------------------------------- | ------------------------------------------ | ------------------- |
| `mongodb.enabled`                            | Enable MongoDB StatefulSet.                | `true`              |
| `mongodb.name`                               | MongoDB component name.                    | `mongodb`           |
| `mongodb.serviceName`                        | Headless service name for StatefulSet DNS. | `mongodb-service`   |
| `mongodb.replicaCount`                       | Number of MongoDB replicas.                | `1`                 |
| `mongodb.image`                              | MongoDB container image settings.          |                     |
| `mongodb.image.repository`                   | Image repository.                          | `mongo`             |
| `mongodb.image.tag`                          | Image tag.                                 | `8`                 |
| `mongodb.containerPort`                      | MongoDB container port.                    | `27017`             |
| `mongodb.storage`                            | Persistent storage configuration.          |                     |
| `mongodb.storage.storageClassName`           | Storage class name.                        | `manual`            |
| `mongodb.storage.size`                       | Volume size.                               | `5Gi`               |
| `mongodb.storage.hostPath`                   | Host path for local storage.               | `/mnt/data/mongodb` |
| `mongodb.resources`                          | MongoDB resource requests and limits.      |                     |
| `mongodb.resources.requests`                 | MongoDB resource requests.                 |                     |
| `mongodb.resources.requests.memory`          | Requested memory.                          | `256Mi`             |
| `mongodb.resources.requests.cpu`             | Requested CPU.                             | `100m`              |
| `mongodb.resources.limits`                   | MongoDB resource limits.                   |                     |
| `mongodb.resources.limits.memory`            | Memory limit.                              | `512Mi`             |
| `mongodb.resources.limits.cpu`               | CPU limit.                                 | `200m`              |
| `mongodb.readinessProbe`                     | MongoDB readiness probe settings.          |                     |
| `mongodb.readinessProbe.initialDelaySeconds` | Initial delay before readiness checks.     | `30`                |
| `mongodb.readinessProbe.periodSeconds`       | Readiness check interval.                  | `10`                |
| `mongodb.readinessProbe.timeoutSeconds`      | Readiness check timeout.                   | `10`                |
| `mongodb.livenessProbe`                      | MongoDB liveness probe settings.           |                     |
| `mongodb.livenessProbe.initialDelaySeconds`  | Initial delay before liveness checks.      | `120`               |
| `mongodb.livenessProbe.periodSeconds`        | Liveness check interval.                   | `60`                |
| `mongodb.livenessProbe.timeoutSeconds`       | Liveness check timeout.                    | `30`                |

### Ingress parameters

| Name                | Description              | Value               |
| ------------------- | ------------------------ | ------------------- |
| `ingress.enabled`   | Enable Ingress resource. | `true`              |
| `ingress.name`      | Ingress resource name.   | `notes-app-ingress` |
| `ingress.className` | Ingress class name.      | `nginx`             |
| `ingress.path`      | Ingress path.            | `/`                 |
| `ingress.pathType`  | Ingress path type.       | `Prefix`            |

----------------------------------------------
Autogenerated from chart metadata using [Bitnami readme-generator-for-helm](https://github.com/bitnami/readme-generator-for-helm)
