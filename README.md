# 🏦 Banking Microservices Project (Kubernetes)

## 📌 Overview
This project demonstrates a production-style Kubernetes deployment for a simple banking system composed of:
- Banking API (Node.js)
- Dashboard (Nginx)
- PostgreSQL Database (StatefulSet)

The system is deployed on a multi-node Minikube cluster with advanced Kubernetes concepts including:
- Node Affinity & Anti-Affinity
- Taints & Tolerations
- StatefulSets
- Horizontal Pod Autoscaler (HPA)
- Ingress
- Network Policies
- RBAC
- DaemonSets (Fluentd logging)

---

## 🧱 Architecture

```
                ┌───────────────┐
                │   Ingress     │
                │ banking.local │
                └──────┬────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
┌───────────────┐           ┌────────────────┐
│ Dashboard     │           │ Banking API    │
│ (Nginx)       │           │ (Node.js)      │
└──────┬────────┘           └──────┬─────────┘
       │                           │
       └──────────────┬────────────┘
                      │
              ┌──────────────┐
              │ PostgreSQL   │
              │ StatefulSet  │
              └──────────────┘
```

---

## ⚙️ Technologies Used

- Docker
- Kubernetes (Minikube - Multi-node)
- Node.js
- Nginx
- PostgreSQL
- Fluentd (Logging)

---

## 📁 Project Structure

```
k8s/
├── 00-namespace.yaml
├── 01-configmap.yaml
├── 02-secret.yaml
├── 03-postgres-statefulset.yaml
├── 04-api-deployment.yaml
├── 05-dashboard-deployment.yaml
├── 06-services.yaml
├── 07-ingress.yaml
├── 08-hpa.yaml
├── 09-rbac.yaml
├── 10-networkpolicy.yaml
├── 11-daemonset-fluentd.yaml
├── 12-setup-nodes.sh
```

---

## 🐳 Docker Images

### API
- Built using Node.js
- Exposes port 3000

### Dashboard
- Built using Nginx
- Serves static frontend

---

## 🧠 Key Kubernetes Concepts Used

### 1. Namespace
Isolates all project resources inside `banking` namespace.

### 2. ConfigMap
Stores environment variables:
- DB_HOST
- DB_PORT
- LOG_LEVEL

### 3. Secret
Stores sensitive data:
- DB_PASSWORD
- JWT_SECRET

### 4. StatefulSet (PostgreSQL)
- 2 replicas
- Persistent storage (PVC)
- Headless service
- Anti-affinity for High Availability

### 5. Deployment (API)
- 2 replicas
- Node Affinity (high-memory nodes)
- Pod Anti-Affinity (spread pods)
- Init Container (wait for DB)
- Liveness & Readiness probes

### 6. Deployment (Dashboard)
- Waits for API using initContainer
- Exposed via service and ingress

### 7. Services
- ClusterIP for internal communication
- Headless service for PostgreSQL

### 8. Ingress
- Host: `banking.local`
- Routes:
  - `/` → Dashboard
  - `/api` → API

### 9. HPA (Horizontal Pod Autoscaler)
- Scales API based on CPU usage

### 10. RBAC
- Role + RoleBinding for pod read access

### 11. Network Policy
- Restricts traffic between components
- Allows only required communication

### 12. DaemonSet (Fluentd)
- Runs on every node
- Collects logs

---

## 🧩 Node Configuration (IMPORTANT)

Run once:

```bash
bash k8s/12-setup-nodes.sh
```

This script:
- Labels nodes (`type=high-memory`)
- Adds taint to DB node

---

## 🚀 How to Run the Project

### 1. Start Minikube 
```bash
minikube start --nodes=3
```

### 2. Setup Nodes
```bash
bash k8s/12-setup-nodes.sh
```

### 3. Deploy Everything
```bash
kubectl apply -f k8s/
```

### 4. Enable Ingress
```bash
minikube addons enable ingress
```

### 5. Access Application

Add to hosts file:
```
<minikube-ip> banking.local
```

Then open:
```
http://banking.local
```

---

## 🔍 Debugging Commands

```bash
kubectl get pods -n banking
kubectl describe pod <pod-name> -n banking
kubectl logs <pod-name> -n banking
kubectl get svc -n banking
kubectl get nodes --show-labels
```

---

## ⚠️ Common Issues & Fixes

### Pod Pending
- Cause: Affinity / Taints
- Fix: Check node labels

### API CrashLoopBackOff
- Cause: DB not ready
- Fix: Init container + correct DB_HOST

### HPA Unknown
- Cause: Missing metrics-server or CPU requests
- Fix: Add resources + enable metrics-server

---

## 🏁 Conclusion

This project demonstrates a complete Kubernetes production-like setup including:
- Scalable architecture
- High availability
- Secure communication
- Observability

---

## 👨‍💻 Author
Anas Galal

---

🔥 This project represents advanced Kubernetes concepts and real-world deployment practices.

