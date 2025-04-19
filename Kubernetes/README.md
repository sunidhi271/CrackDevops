# 📘 Kubernetes Interview Questions & Concepts
A comprehensive list of Kubernetes questions, explanations, and best practices for interviews and deep dives.

📚 Table of Contents


#### ✅ Basics
Q: Explain Kubernetes Architecture
```
1. kube-controller-manager: Controls the scale up, scale down, job scheduling and everyting that happens in the cluster. Makes sure expected state = desired
2. kube apiserver: It helps in communication between control plane and nodes. All kubectl commands are received by this component over REST API.
3. ETCD: Keeps all the cluster data and data abt current state , expected state etc and help kube-controller manager
4. Scheduler: Schedules pods based on the resource availability in nodes
5. Container runtime: Makes sure that the containers are running fine
6. kubelet: Runs on each nodes, communicates with kube-controller-manager, ensures pods are running. Monitors container health and restarts them.
7. Kube-proxy: The component that is responible for handling the network communication and service routing on each node.
```
Q: How Kubernetes Components Communicate ?
```
1. User runs command → kube-apiserver authenticates the user and receives it.
2. API server updates desired state in ETCD.
3. kube-controller-manager notices state drift → informs scheduler.
4. Scheduler assigns pod to a node.
5. kubelet gets instruction → container runtime runs the pod.
6. kubelet reports back to API server → ETCD is updated with current state.
```
Q: What is the purpose of the kube-proxy component in a Kubernetes cluster, and how does it enable network communication?
```
It manages network traffic by routing it to the corrcet svc and pod. It loadbalances the traffic, responsible for pod-to-pod, communications as well.
```
Q: What is the role of the cAdvisor (Container Advisor) in a Kubernetes cluster, and how does it collect container resource metrics?
```
What ? It is a comonent integrated in kubelet, it collects (performance, resource usage data of the pods) data from kernel.
How ?
- Uses the cgroups (control groups) mechanism in the Linux kernel to track resource usage.
- exposes the metrics via kubelet API /metrics/cadvisor
- HPA gets metrics from cadvisor to scale up and scale down.
```
Q: Only one component is allowed to talk to etcd, what is that ?
```
Only kube-apiserver directly communicates with ETCD
```
Q: Explain the role of the kubelet in a Kubernetes cluster and how it interacts with other components ?
```
- Node agent : The kubelet is the node agent that runs on each worker node in a Kubernetes cluster. 
- Ensures pod health and status :  It ensures that the pods scheduled to the node are running and healthy by constantly checking their status.
- Talks to container runtime: The kubelet reads the PodSpecs provided by the Kube-API Server, then interacts with the container runtime ( Docker) to launch and manage containers.
```

Q: In which namespace all the control plane pods get created ?
```
kube-system
```
Q: What happens in the background when we run "kubectl scale replica" command ? 
```
- READ operation: kube apiserver, authenticates based on the certificate and all and gets the data from etcd
- Write operation: kube apiserver updates desired state in etcd, kube-apiserver observes the difference and calls scheduler to schedule the pod,
which inturn calls kubelet to make the changes, kubelet communicates with dockerruntime run the new pod.
```
Q: What are different types of Kubernetes Services ?
```
1. CLUSTER-IP: exposes svc internally within cluster (curl http://<svc name>:80)
2. Loadbalancer: To provision cloud based external load balancer (curl http://<External-IP>:80
3. Node-Exporter: Exposes the service on a static port (30000-32767) on each node’s IP. (curl http://<NodeIP>:80
```
Q: Can We Have Multiple ETCD Instances in a Kubernetes Cluster?
```
Yes, production-grade Kubernetes clusters use an ETCD cluster (typically odd number like 3, 5, 7) for high availability.
```
Q: How to do ETCD Backup and Restore ?
```
# Backup
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date).db --endpoints=https://127.0.0.1:2379 --cacert <path> --cert <path> --key <path>

# Restore
systemctl stop kube-apiserver
ETCDCTL_API=3 etcdctl snapshot restore /backup/etcd-$(date).db --data-dir=/var/lib/etcd-backup
systemctl restart etcd
systemctl restart kube-apiserver
```
Q: What Happens When ETCD Goes Down
```
- Kubernetes cannot store or retrieve cluster state.
- Control plane operations (like scheduling) halt.
- Existing pods keep running but changes won't persist.
```
Q: What is difference between Deployment, StatefulSet and DaemonSet ?
| Feature      | Deployment               | StatefulSet             | DaemonSet                 |
|--------------|--------------------------|-------------------------|---------------------------|
| Use Case     | Stateless apps           | Stateful apps           | One pod per node          |
| Example      | web app (e.g., NGINX)    | Stateful DB (e.g., MongoDB, Kafka) | used to host monitoring agents and log collectors |
| Pod Name     | Random                   | pod-0, pod-1            | Random                    |
| Scale Order  | Parallelly, in rolling update (one pod replaces the other)                | Sequentially                 | new pod gets added on node addition             |
| Re-Scheduling| New Pod Name             | Same Pod Name           | On new node               |

Q: How does Kubernetes handle high availability for microservices ?
```
- Rolling updates, auto healing
- HPA for scaling
- Pod AntiAffinity rules
- TLS ingress with load balancing
```
Q: How does Kubernetes Ingress work? How it is different from loadbalancers ?
```
- Instead of a creating loadbalancer service for every single service, we create ingress to expose different path/apis of applications through diff svc.
- The traffic is routed based on hostname and path.
- It can also integrate with TLS for HTTPS.
```
Q: How does Kubernetes perform rolling updates and rollbacks?
```
- Restarts one pod at a time, with traffic coming to the other pod or the new pod, based on maxUnavailable and maxSurge parameters
- To do rolling update change any parametr in the deployment e.g, k set image deployment/my-app my-container=apline:v2
- To do rollback: k rollout history deployment/my-app  -> k rollout undo deployment/my-app  /  k rollout undo deployment/my-app --to-revision=2
```
Q: What is evicted pod and what happens when a Kubernetes Pod is evicted?
```
Evicted pods are those which are forcibly removed. Pod doesnt restart when evicted unles it is deployment/daemoset/sts. 
```
Q: Explain the working of Persistent Volumes and StorageClasses in Kubernetes.
```
- PV: Actual storage resource
- PVC: Claim/request for PV
- StorageClass: Defines dynamic provisioning details
```
Q: How many types of pods are there ?
```
Static pod: A Pod not managed by the Kubernetes API server, but by the kubelet on a node.
Regular pods: pods created by sts, deployment, cronjob, initcontainers etc.
```
Q: Explain the difference between a Rolling Update and a Blue-Green Deployment in Kubernetes ?

| Strategy   | Description |
| Rolling    | One pod at a time replaced |
| Blue-Green | Deploy full new version in parallel, switch traffic after validation |
| Canary     | Limited traffic to new version for testing |

Q: What is the Horizontal Pod Autoscaler (HPA) in Kubernetes, and how does it work?
```
- It gets the CPU/memory data from caadvisor.
- based on whatever metrics we set in HPA, it scales up or scales down the resource accordingly.
```
Q: Difference between Ingress and Loadbalancer ?
| Feature           | Ingress | LoadBalancer    |
| HTTP Routing      | ✅     | ❌              |
| Multiple services | ✅     | ❌              |
| TLS Support       | ✅     | ❌ (via ingress)|
| Cloud Dependency  | ❌     | ✅              |

Q: Is it possible to have One Pod with multiple pvc of different namespaces attached ?
```
- Not supported directly.
- PVC with accessMode ReadWriteMany , can be used by mutiple pod but in same namespace.
```
Q: How does Kubernetes schedule pods onto nodes ?
```
Scheduler checks resource availability, affinity rules, taints/tolerations
```
Q: What is pod AntiAffinity Rule ?
```
- Its a rule that prevents pods from getting scheduled on the same node, useful when we have mutiple replicas of deployment/sts
- ensures the pods with label defined labelselector matchlabel , are not scheduled in same node.
- requiredDuringScedulingIgnoreSuringExecution - (hard rule)
- prefferedDuringSchedulingIgnoreDuringExecution - (weight we have to define)
```

Q: Explain how pod affinity and antiAffinity, tains and tolerations work together to influence pod scheduling decisions.
```
🧭 Pod Affinity
- Attracts a pod to be scheduled on the same node (or topology) as other specific pods.
Example: "Schedule this pod on a node where another pod with label app=backend is running."

🚫 Pod Anti-Affinity
- Avoids scheduling a pod on the same node (or topology) as other specific pods.
Example: "Do not place this pod on a node where a pod with label app=backend already exists."

⚠️ Taints
- Applied to nodes to repel pods unless the pods tolerate the taint.
Example: "This node is reserved for GPU workloads."

✅ Tolerations
- Applied to pods to allow them to be scheduled on nodes with matching taints.
Example: "This pod can run on nodes tainted with key=gpu:NoSchedule."

🧩 Together, they balance node eligibility (via taints/tolerations) and placement preference or rules (via affinity/anti-affinity).
```

Q: What role does DNS resolution play in inter-pod communication? 
```
- When a pod tries to connect to a URL, coreDNS resolves it to the remote IP and then sends traffic to it.
- When a pod tries to connect to a svc in the same cluster then, it does - curl http://service.namespace.svc.cluster.local
```


#### 🧱 Kubernetes Best Practices
Q: What are the key security best practices for running Kubernetes clusters in production?
```
- Cluster Security:	Use the latest Kubernetes version, restrict API access, enable RBAC
- Auth & Access:	Enforce strong authentication, restrict service account permissions
- Network Security:	Use NetworkPolicies, TLS encryption, and WAF
- Container Security: Use minimal base images, non-root users, and security contexts
- Secrets Management: Use Kubernetes Secrets, external vaults, and RBAC
- Monitoring & Logging:	Enable audit logs, Kube-bench, and centralized logging
```
Q: How do you implement disaster recovery and backup strategies for Kubernetes clusters?
```
- ETCD Backup
- pvc backup using velero
- Kubernetes manifest backup: k get all --all-namespaces -o yaml > backup-file.yaml
- Implement Gitops
- Deploy k8s accross mutiple regions
- Strong monitoring and alerting
```


#### ⛑ Troubleshooting Related Questions
Q:  How do you debug a failing pod in Kubernetes?
```
kubectl describe pod <name>
kubectl logs <name>
kubectl top pod <name>
```
Q: How would you troubleshoot a network connectivity issue in a Kubernetes cluster?
```
- Check DNS resolution (nslookup)
- Port-forward the service of the application to check whether the app is working properly of not
- Check Network policies
- Check the status LoadBalancer or Ingress controller
- Check kube-proxy logs
```
Q: What challenges might you encounter during the installation of a Kubernetes cluster, and how would you troubleshoot them ?
```
- Networking config
- ETCD setup
- Certificates
- kubelet startup issues
```
Q: What happens when there is a resource constraint or if a node is tainted? 
```
- If kubescheduler cannt find enough resources, then it puts the new pods in Pending state.
- If scheduler can not schedule any resource then pods go to Evicted state (except Priority pods and daemonset, it evicts all other pods)
- If a node is tainted then pods that do not have the toleration defined in the pod, matching the taint, can not be scheduled in that node.
Those pods stay in pending state. 
```
Q: What happens if a pod behind a Service is deleted ?
```
1. Service automatically updates its list of endpoints (targets) by removing the deleted pod.
2. Kube-proxy updates rules, so traffic is no longer routed to the deleted pod.
3. If a controller (like Deployment) manages the pod, it will create a replacement pod to maintain the desired replica count.
The new pod (once ready) is automatically added back to the service endpoints.
```
Q: How Kubernetes Handles Node Failure ?
```
When a node fails (e.g., crashes, network loss), Kubernetes handles it as follows:
1. Node Heartbeats Stop:
- The Kubelet on each node sends heartbeats to the API server (via the Node object).
- If these stop for a default of 5 minutes (node-monitor-grace-period), the node is marked NotReady.

2. Pods on the Failed Node:
- The kube-controller-manager notices the node is unresponsive.
- After a default of 5 more minutes (pod-eviction-timeout), it evicts pods from the node.
- If the evicted pods were managed by a controller (like a Deployment, ReplicaSet, StatefulSet), it schedules replacement pods on healthy nodes automatically.

3. Service Impact:
The service stops routing traffic to pods on the failed node, thanks to updated endpoints. 
```

Q: How do you audit and troubleshoot RBAC issues, and what tools or methods do you use? 
Suppose I have a kubeconfig to access the cluster, but its not working with my username ?
```
- Checks if a user has permission to perform an action: kubectl auth can-i get pods --as=my-username
- Check RBAC Bindings, i.e, RoleBindings and ClusterRoleBindings, to check which roles have been assigned.
    - kubectl get rolebinding,clusterrolebinding -A | grep my-username
    - kubectl describe rolebinding <name> -n <namespace>
- Check if the bound role actually allows the required action: kubectl get clusterrole <name> -o yaml
- Check Kubeconfig: kubectl config view | kubectl config current-context | kubectl config get-users
- If kubeconfig is not working, then validate the token.
- If kubeconfig is not working and token is correct, then validate the certificate used in it.
- Check logs of the Kubernetes API server or use audit logs (if available) for access denials.
```

#### 📝 Questions to check Hands-on experience 
Q: Write command to check Non-Running Pods
```
kubectl get pods --all-namespaces --field-selector=status.phase!=Running
OR
kubectl get pods -A | grep -E "CrashLoopBackOff|Failed|Error|Pending|Terminating"
```
Q: What are different states of a container ?
```
CrashLoopBackOff, Init:CrashLoopBackOff, Failed, Succeeded, Error, Pending, Terminating
```
Q:  Command to View Pod Resource Usage ?
```
kubectl top pods -A
```
Q: Write a kubectl imperative command to run a nginx container ?
```
kubectl run my-nginx --image=nginx:latest
```
Q: How to create your own API version ? 
```
Define custom CRDs (Custom Resource Definitions)
Group/versioning using apiVersion: yourgroup/v1
```
Q:  Tell us few kubernetes commands that one can use for debugging any issue ?
```
kubectl get events
kubectl describe <resource>
kubectl logs <pod>
kubectl get endpoints
```

Q: How to you create a network policy that restricts the traffic from namespace A to another namespace B only. Just write the spec of that
```
spec:
  podSelector: {}  # Applies to all Pods in Namespace B
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: A  # Only allow traffic from Namespace A
  policyTypes:
    - Ingress
```


