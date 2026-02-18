# notes-app

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Full stack notes app chart managed by Flux

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.containerPort | int | `5000` | Backend container port |
| backend.enabled | bool | `true` | Enable backend deployment |
| backend.env | object | `{"mongodbUri":"mongodb://mongodb-0.mongodb-service:27017/notes-app","nodeEnv":"production"}` | Backend environment variables |
| backend.env.mongodbUri | string | `"mongodb://mongodb-0.mongodb-service:27017/notes-app"` | MongoDB connection URI |
| backend.env.nodeEnv | string | `"production"` | Node environment |
| backend.image | object | `{"pullPolicy":"Always","repository":"chenarrr/devops","tag":"backend-a725016"}` | Backend container image settings |
| backend.image.pullPolicy | string | `"Always"` | Image pull policy |
| backend.image.repository | string | `"chenarrr/devops"` | Image repository |
| backend.image.tag | string | `"backend-a725016"` | Image tag |
| backend.livenessProbe | object | `{"initialDelaySeconds":120,"path":"/api/notes","periodSeconds":60,"timeoutSeconds":30}` | Backend liveness probe |
| backend.name | string | `"backend"` | Backend component name |
| backend.podSecurityContext | object | `{"fsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Pod-level security context |
| backend.readinessProbe | object | `{"initialDelaySeconds":30,"path":"/api/notes","periodSeconds":10,"timeoutSeconds":10}` | Backend readiness probe |
| backend.replicaCount | int | `1` | Number of backend replicas |
| backend.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Backend resource requests and limits |
| backend.securityContext | object | `{"allowPrivilegeEscalation":false,"readOnlyRootFilesystem":false}` | Container-level security context |
| backend.service | object | `{"port":5000,"type":"ClusterIP"}` | Backend service configuration |
| backend.service.port | int | `5000` | Service port |
| backend.service.type | string | `"ClusterIP"` | Service type |
| frontend | object | `{"containerPort":80,"enabled":true,"image":{"pullPolicy":"Always","repository":"chenarrr/devops","tag":"frontend-a725016"},"livenessProbe":{"initialDelaySeconds":30,"path":"/","periodSeconds":60,"timeoutSeconds":10},"name":"frontend","readinessProbe":{"initialDelaySeconds":5,"path":"/","periodSeconds":10,"timeoutSeconds":3},"replicaCount":1,"resources":{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}},"securityContext":{"allowPrivilegeEscalation":false},"service":{"port":80,"type":"ClusterIP"}}` | Frontend web server configuration |
| frontend.containerPort | int | `80` | Frontend container port |
| frontend.enabled | bool | `true` | Enable frontend deployment |
| frontend.image | object | `{"pullPolicy":"Always","repository":"chenarrr/devops","tag":"frontend-a725016"}` | Frontend container image settings |
| frontend.image.pullPolicy | string | `"Always"` | Image pull policy |
| frontend.image.repository | string | `"chenarrr/devops"` | Image repository |
| frontend.image.tag | string | `"frontend-a725016"` | Image tag |
| frontend.livenessProbe | object | `{"initialDelaySeconds":30,"path":"/","periodSeconds":60,"timeoutSeconds":10}` | Frontend liveness probe |
| frontend.name | string | `"frontend"` | Frontend component name |
| frontend.readinessProbe | object | `{"initialDelaySeconds":5,"path":"/","periodSeconds":10,"timeoutSeconds":3}` | Frontend readiness probe |
| frontend.replicaCount | int | `1` | Number of frontend replicas |
| frontend.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Frontend resource requests and limits |
| frontend.securityContext | object | `{"allowPrivilegeEscalation":false}` | Container-level security context |
| frontend.service | object | `{"port":80,"type":"ClusterIP"}` | Frontend service configuration |
| frontend.service.port | int | `80` | Service port |
| frontend.service.type | string | `"ClusterIP"` | Service type |
| fullnameOverride | string | `"notes-app"` | Override the full release name |
| ingress | object | `{"annotations":{"nginx.ingress.kubernetes.io/proxy-body-size":"10m"},"className":"nginx","enabled":true,"name":"notes-app-ingress","path":"/","pathType":"Prefix"}` | Ingress configuration |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/proxy-body-size":"10m"}` | Ingress annotations |
| ingress.className | string | `"nginx"` | Ingress class name |
| ingress.enabled | bool | `true` | Enable Ingress resource |
| ingress.name | string | `"notes-app-ingress"` | Ingress resource name |
| ingress.path | string | `"/"` | Ingress path |
| mongodb | object | `{"containerPort":27017,"enabled":true,"image":{"repository":"mongo","tag":"8"},"livenessProbe":{"initialDelaySeconds":120,"periodSeconds":60,"timeoutSeconds":30},"name":"mongodb","readinessProbe":{"initialDelaySeconds":30,"periodSeconds":10,"timeoutSeconds":10},"replicaCount":1,"resources":{"limits":{"cpu":"200m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}},"serviceName":"mongodb-service","storage":{"hostPath":"/mnt/data/mongodb","size":"5Gi","storageClassName":"manual"}}` | MongoDB database configuration |
| mongodb.containerPort | int | `27017` | MongoDB container port |
| mongodb.enabled | bool | `true` | Enable MongoDB StatefulSet |
| mongodb.image | object | `{"repository":"mongo","tag":"8"}` | MongoDB container image settings |
| mongodb.image.repository | string | `"mongo"` | Image repository |
| mongodb.image.tag | string | `"8"` | Image tag |
| mongodb.livenessProbe | object | `{"initialDelaySeconds":120,"periodSeconds":60,"timeoutSeconds":30}` | MongoDB liveness probe |
| mongodb.name | string | `"mongodb"` | MongoDB component name |
| mongodb.readinessProbe | object | `{"initialDelaySeconds":30,"periodSeconds":10,"timeoutSeconds":10}` | MongoDB readiness probe |
| mongodb.replicaCount | int | `1` | Number of MongoDB replicas |
| mongodb.resources | object | `{"limits":{"cpu":"200m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | MongoDB resource requests and limits |
| mongodb.serviceName | string | `"mongodb-service"` | Headless service name for StatefulSet DNS |
| mongodb.storage | object | `{"hostPath":"/mnt/data/mongodb","size":"5Gi","storageClassName":"manual"}` | Persistent storage configuration |
| mongodb.storage.hostPath | string | `"/mnt/data/mongodb"` | Host path for local storage |
| mongodb.storage.size | string | `"5Gi"` | Volume size |
| mongodb.storage.storageClassName | string | `"manual"` | Storage class name |
| nameOverride | string | `""` | Override the chart name |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
