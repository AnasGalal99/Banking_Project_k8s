# 🏦 Banking Microservices Project (Kubernetes)

## 📌 Overview

This project demonstrates a **production-style Kubernetes deployment** for a banking system running on a **multi-node Minikube cluster**.

It includes real-world concepts like scheduling, networking, security, observability, and troubleshooting.

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

* Docker
* Kubernetes (Minikube - Multi-node cluster)
* Node.js
* Nginx
* PostgreSQL
* Fluentd (Logging)
* Metrics Server

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

## 🧠 Key Kubernetes Concepts

### 🔹 Scheduling & Nodes

* Node Labels (`type=high-memory`)
* Node Affinity & Anti-Affinity
* Taints & Tolerations (Database isolation)

### 🔹 Workloads

* Deployment (API & Dashboard)
* StatefulSet (PostgreSQL with persistence)
* DaemonSet (Fluentd logging)

### 🔹 Networking

* ClusterIP Services
* Headless Service (PostgreSQL)
* Ingress (NGINX Controller)

### 🔹 Security

* RBAC
* Secrets management
* Network Policies (Default Deny)

### 🔹 Scalability

* Horizontal Pod Autoscaler (HPA)

---

## 🔐 Network Policy Strategy

Implemented a **Zero Trust model**:

* Deny all traffic by default
* Allow only required communication:

  * Ingress → Dashboard
  * Ingress → API
  * Dashboard → API
  * API → Database
  * DNS access

---

## 🌐 Ingress Configuration

* Host: `banking.local`
* Routes:

  * `/` → Dashboard
  * `/api` → Banking API

---

## 🚀 How to Run

### 1. Start Minikube

```bash
minikube start --nodes=3 --cpus=4 --memory=8192
```

### 2. Setup Nodes

```bash
bash k8s/12-setup-nodes.sh
```

### 3. Deploy

```bash
kubectl apply -f k8s/
```

### 4. Enable Ingress

```bash
minikube addons enable ingress
```

### 5. Enable Metrics

```bash
minikube addons enable metrics-server
```

### 6. Fix Metrics Server (Minikube)

```bash
kubectl patch deployment metrics-server -n kube-system \
--type='json' \
-p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

### 7. Start Tunnel

```bash
minikube tunnel
```

### 8. Access

Add to `/etc/hosts`:

```
<minikube-ip> banking.local
```

Open:

```
http://banking.local
```

---

## 🧪 Testing & Validation

### Check Pods

```bash
kubectl get pods -n banking
```

### Test API

```bash
kubectl port-forward svc/banking-api-service 3001:3000 -n banking
curl http://localhost:3001/health
```

### Test Ingress

```bash
curl -H "Host: banking.local" http://$(minikube ip)
```

---

## ⚠️ Real Issues & Solutions

### 🔸 Ingress Not Working

* Cause: Controller scheduling failure due to taints
* Fix: Adjusted node configuration

---

### 🔸 Pods Stuck in Pending

* Cause: Node affinity conflicts
* Fix: Correct labeling and scheduling rules

---

### 🔸 ImagePullBackOff

* Cause: Network issues inside Minikube
* Fix:

```bash
minikube ssh
docker pull <image>
```

---

### 🔸 HPA showing `<unknown>`

* Cause: Metrics Server not configured
* Fix: Enabled and patched metrics-server

---

### 🔸 DNS / Service Resolution Issues

* Cause: Testing from wrong namespace
* Fix: Used correct namespace or FQDN

---

### 🔸 NetworkPolicy Blocking Traffic

* Cause: Default deny configuration
* Fix: Designed precise allow rules

---

## 🏁 Conclusion

This project demonstrates:

* Real-world Kubernetes deployment
* Secure networking (Zero Trust)
* Scalable microservices architecture
* Advanced debugging and troubleshooting

---

## 👨‍💻 Author

**Anas Galal**

---

🔥 This project reflects hands-on experience with real Kubernetes challenges and solutions.
