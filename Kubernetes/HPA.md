<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/894e868e-b795-4f5a-86a3-e22b7cf23fc3" />Q: How to Auto-scale a Deployment using HPA?
```
# Create HPA
kubectl autoscale deployment myapp --cpu-percent=50 --min=1 --max=5

#Verify HPA
kubectl get hpa
kubectl describe hpa myapp
```
Q: What are pre-requisites for HPA to work ?
```
1. metrics-server or custom metrics API should be existing in cluster
```
Q: How HPA Calculates the desired Replicas ?
```
Desired Replicas = Current Replicas × (Current Metric Value / Target Metric Value)
```
Q: How HPA works ?
```
1️⃣ HPA periodically checks metrics (via metrics-server or custom metrics API).
2️⃣ If usage exceeds target threshold, HPA increases replicas.
3️⃣ If usage goes below threshold, HPA decreases replicas.
```

Q: What is the apiVerion of HPA ?
```
autoscaling/v1
autoscaling/v2
autoscaling/v2beta2
```
Q: How HPA works in backend ?
```
1. Metrics server collects the metrics from KUBELET and exposes them to KUBE API SERVER APIs.
2. KUBECONTROLLER MANAGER deploys the HPA in the control plane.
3. HPA periodically collects metrics from KUBE API SERVER.
4. HPA calculates the desired replicas and updates the API SERVER about the number of replicas.
5. KUBE API SERVER updates ETCD with the desired number of replicas.
6. KUBE CONTROLLER MANAGER gets the replica change from ETCD and instructs the REPLICASET CONTROLLER to create replicas.
7. SCHEDULER ensures that the desired number of pods are created, on suitable nodes.
```
