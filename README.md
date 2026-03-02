# notes-app

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Full stack notes app chart managed by Flux

## Parameters

### Common parameters

| Name               | Description                                            | Value       |
| ------------------ | ------------------------------------------------------ | ----------- |
| `fullnameOverride` | Override the full release name used for all resources. | `notes-app` |

### Backend parameters

| Name                                               | Description                                                                      | Value                                                 |
| -------------------------------------------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `backend.enabled`                                  | Enable or disable the backend Deployment and Service.                            | `true`                                                |
| `backend.name`                                     | Name used for the backend Deployment, Service, and labels.                       | `backend`                                             |
| `backend.replicaCount`                             | Number of backend pod replicas to run.                                           | `1`                                                   |
| `backend.image`                                    | Backend container image configuration.                                           |                                                       |
| `backend.image.repository`                         | Docker image repository for the backend.                                         | `chenarrr/devops`                                     |
| `backend.image.tag`                                | Docker image tag for the backend.                                                | `backend-a725016`                                     |
| `backend.image.pullPolicy`                         | Image pull policy (Always, IfNotPresent, Never).                                 | `Always`                                              |
| `backend.containerPort`                            | Port the backend container listens on.                                           | `5000`                                                |
| `backend.service`                                  | Backend Kubernetes Service configuration.                                        |                                                       |
| `backend.service.type`                             | Kubernetes Service type (ClusterIP, NodePort, LoadBalancer).                     | `ClusterIP`                                           |
| `backend.service.port`                             | Port exposed by the backend Service.                                             | `5000`                                                |
| `backend.env`                                      | Environment variables injected into the backend container.                       |                                                       |
| `backend.env.mongodbUri`                           | Full MongoDB connection URI used by the backend.                                 | `mongodb://mongodb-0.mongodb-service:27017/notes-app` |
| `backend.env.nodeEnv`                              | Node.js runtime environment (production, development).                           | `production`                                          |
| `backend.podSecurityContext`                       | Security context applied at the pod level.                                       |                                                       |
| `backend.podSecurityContext.runAsNonRoot`          | Require the container to run as a non-root user.                                 | `true`                                                |
| `backend.podSecurityContext.runAsUser`             | UID for the container process.                                                   | `1000`                                                |
| `backend.podSecurityContext.fsGroup`               | GID applied to mounted volumes for file access.                                  | `1000`                                                |
| `backend.securityContext`                          | Security context applied at the container level.                                 |                                                       |
| `backend.securityContext.allowPrivilegeEscalation` | Prevent the process from gaining extra privileges.                               | `false`                                               |
| `backend.securityContext.readOnlyRootFilesystem`   | Mount the container root filesystem as read-only.                                | `false`                                               |
| `backend.resources`                                | CPU and memory resource requests and limits for the backend container.           |                                                       |
| `backend.resources.requests`                       | Minimum resources guaranteed to the backend container.                           |                                                       |
| `backend.resources.requests.memory`                | Minimum memory allocated to the backend container.                               | `64Mi`                                                |
| `backend.resources.requests.cpu`                   | Minimum CPU allocated to the backend container.                                  | `10m`                                                 |
| `backend.resources.limits`                         | Maximum resources the backend container is allowed to consume.                   |                                                       |
| `backend.resources.limits.memory`                  | Maximum memory the backend container can use.                                    | `256Mi`                                               |
| `backend.resources.limits.cpu`                     | Maximum CPU the backend container can use.                                       | `200m`                                                |
| `backend.readinessProbe`                           | HTTP readiness probe to determine when the backend is ready to serve traffic.    |                                                       |
| `backend.readinessProbe.path`                      | HTTP path used by the readiness probe.                                           | `/api/notes`                                          |
| `backend.readinessProbe.initialDelaySeconds`       | Seconds to wait before the first readiness check.                                | `30`                                                  |
| `backend.readinessProbe.periodSeconds`             | Interval in seconds between readiness checks.                                    | `10`                                                  |
| `backend.readinessProbe.timeoutSeconds`            | Seconds before a readiness check times out.                                      | `10`                                                  |
| `backend.livenessProbe`                            | HTTP liveness probe to restart the backend container if it becomes unresponsive. |                                                       |
| `backend.livenessProbe.path`                       | HTTP path used by the liveness probe.                                            | `/api/notes`                                          |
| `backend.livenessProbe.initialDelaySeconds`        | Seconds to wait before the first liveness check.                                 | `120`                                                 |
| `backend.livenessProbe.periodSeconds`              | Interval in seconds between liveness checks.                                     | `60`                                                  |
| `backend.livenessProbe.timeoutSeconds`             | Seconds before a liveness check times out.                                       | `30`                                                  |

### Frontend parameters

| Name                                                | Description                                                                       | Value              |
| --------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------ |
| `frontend.enabled`                                  | Enable or disable the frontend Deployment and Service.                            | `true`             |
| `frontend.name`                                     | Name used for the frontend Deployment, Service, and labels.                       | `frontend`         |
| `frontend.replicaCount`                             | Number of frontend pod replicas to run.                                           | `1`                |
| `frontend.image`                                    | Frontend container image configuration.                                           |                    |
| `frontend.image.repository`                         | Docker image repository for the frontend.                                         | `chenarrr/devops`  |
| `frontend.image.tag`                                | Docker image tag for the frontend.                                                | `frontend-a725016` |
| `frontend.image.pullPolicy`                         | Image pull policy (Always, IfNotPresent, Never).                                  | `Always`           |
| `frontend.containerPort`                            | Port the frontend container (NGINX) listens on.                                   | `80`               |
| `frontend.service`                                  | Frontend Kubernetes Service configuration.                                        |                    |
| `frontend.service.type`                             | Kubernetes Service type (ClusterIP, NodePort, LoadBalancer).                      | `ClusterIP`        |
| `frontend.service.port`                             | Port exposed by the frontend Service.                                             | `80`               |
| `frontend.resources`                                | CPU and memory resource requests and limits for the frontend container.           |                    |
| `frontend.resources.requests`                       | Minimum resources guaranteed to the frontend container.                           |                    |
| `frontend.resources.requests.memory`                | Minimum memory allocated to the frontend container.                               | `64Mi`             |
| `frontend.resources.requests.cpu`                   | Minimum CPU allocated to the frontend container.                                  | `50m`              |
| `frontend.resources.limits`                         | Maximum resources the frontend container is allowed to consume.                   |                    |
| `frontend.resources.limits.memory`                  | Maximum memory the frontend container can use.                                    | `128Mi`            |
| `frontend.resources.limits.cpu`                     | Maximum CPU the frontend container can use.                                       | `100m`             |
| `frontend.securityContext`                          | Security context applied at the container level.                                  |                    |
| `frontend.securityContext.allowPrivilegeEscalation` | Prevent the process from gaining extra privileges.                                | `false`            |
| `frontend.readinessProbe`                           | HTTP readiness probe to determine when the frontend is ready to serve traffic.    |                    |
| `frontend.readinessProbe.path`                      | HTTP path used by the readiness probe.                                            | `/`                |
| `frontend.readinessProbe.initialDelaySeconds`       | Seconds to wait before the first readiness check.                                 | `5`                |
| `frontend.readinessProbe.periodSeconds`             | Interval in seconds between readiness checks.                                     | `10`               |
| `frontend.readinessProbe.timeoutSeconds`            | Seconds before a readiness check times out.                                       | `3`                |
| `frontend.livenessProbe`                            | HTTP liveness probe to restart the frontend container if it becomes unresponsive. |                    |
| `frontend.livenessProbe.path`                       | HTTP path used by the liveness probe.                                             | `/`                |
| `frontend.livenessProbe.initialDelaySeconds`        | Seconds to wait before the first liveness check.                                  | `30`               |
| `frontend.livenessProbe.periodSeconds`              | Interval in seconds between liveness checks.                                      | `60`               |
| `frontend.livenessProbe.timeoutSeconds`             | Seconds before a liveness check times out.                                        | `10`               |

### MongoDB parameters

| Name                                         | Description                                                             | Value               |
| -------------------------------------------- | ----------------------------------------------------------------------- | ------------------- |
| `mongodb.enabled`                            | Enable or disable the MongoDB StatefulSet and its supporting resources. | `true`              |
| `mongodb.name`                               | Name used for the MongoDB StatefulSet and labels.                       | `mongodb`           |
| `mongodb.serviceName`                        | Name of the headless Service used for StatefulSet DNS-based discovery.  | `mongodb-service`   |
| `mongodb.replicaCount`                       | Number of MongoDB pod replicas (keep at 1 unless using a replica set).  | `1`                 |
| `mongodb.image`                              | MongoDB container image configuration.                                  |                     |
| `mongodb.image.repository`                   | Docker image repository for MongoDB.                                    | `mongo`             |
| `mongodb.image.tag`                          | Docker image tag for MongoDB.                                           | `8`                 |
| `mongodb.containerPort`                      | Port the MongoDB container listens on.                                  | `27017`             |
| `mongodb.storage`                            | Persistent storage configuration for the MongoDB data directory.        |                     |
| `mongodb.storage.storageClassName`           | StorageClass used by the PersistentVolumeClaim.                         | `manual`            |
| `mongodb.storage.size`                       | Size of the PersistentVolume requested for MongoDB data.                | `5Gi`               |
| `mongodb.storage.hostPath`                   | Absolute path on the host node where MongoDB data is stored.            | `/mnt/data/mongodb` |
| `mongodb.resources`                          | CPU and memory resource requests and limits for the MongoDB container.  |                     |
| `mongodb.resources.requests`                 | Minimum resources guaranteed to the MongoDB container.                  |                     |
| `mongodb.resources.requests.memory`          | Minimum memory allocated to the MongoDB container.                      | `256Mi`             |
| `mongodb.resources.requests.cpu`             | Minimum CPU allocated to the MongoDB container.                         | `50m`               |
| `mongodb.resources.limits`                   | Maximum resources the MongoDB container is allowed to consume.          |                     |
| `mongodb.resources.limits.memory`            | Maximum memory the MongoDB container can use.                           | `512Mi`             |
| `mongodb.resources.limits.cpu`               | Maximum CPU the MongoDB container can use.                              | `200m`              |
| `mongodb.readinessProbe`                     | Exec readiness probe to check if MongoDB is accepting connections.      |                     |
| `mongodb.readinessProbe.initialDelaySeconds` | Seconds to wait before the first readiness check.                       | `30`                |
| `mongodb.readinessProbe.periodSeconds`       | Interval in seconds between readiness checks.                           | `10`                |
| `mongodb.readinessProbe.timeoutSeconds`      | Seconds before a readiness check times out.                             | `10`                |
| `mongodb.livenessProbe`                      | Exec liveness probe to restart MongoDB if it becomes unresponsive.      |                     |
| `mongodb.livenessProbe.initialDelaySeconds`  | Seconds to wait before the first liveness check.                        | `120`               |
| `mongodb.livenessProbe.periodSeconds`        | Interval in seconds between liveness checks.                            | `60`                |
| `mongodb.livenessProbe.timeoutSeconds`       | Seconds before a liveness check times out.                              | `30`                |

### Ingress parameters

| Name                                                              | Description                                                         | Value               |
| ----------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `ingress.enabled`                                                 | Enable or disable the Ingress resource.                             | `true`              |
| `ingress.name`                                                    | Name of the Ingress resource.                                       | `notes-app-ingress` |
| `ingress.annotations`                                             | Annotations applied to the Ingress resource.                        |                     |
| `ingress.annotations.nginx.ingress.kubernetes.io/proxy-body-size` | Maximum allowed request body size for the NGINX ingress controller. | `10m`               |
| `ingress.className`                                               | Ingress class name that selects the ingress controller to use.      | `nginx`             |
| `ingress.path`                                                    | URL path prefix that the Ingress routes to the frontend Service.    | `/`                 |
| `ingress.pathType`                                                | Ingress path matching type (Prefix, Exact, ImplementationSpecific). | `Prefix`            |

----------------------------------------------
Autogenerated from chart metadata using [Bitnami readme-generator-for-helm](https://github.com/bitnami/readme-generator-for-helm)
