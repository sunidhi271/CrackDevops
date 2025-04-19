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

Q: What is the Horizontal Pod Autoscaler (HPA) in Kubernetes, and how does it work?
```
- It is a built in feature of Kubernetes which helps us to scale deployments/sts based on specified targets.
- It relies on metrics-server to see cpu and memory.
- If you have some custom metrics (like request rate, then that can be used to onfigure HPA)
```

Q: How can you secure communication within a Kubernetes cluster?  
```
- Using RBAC we can control a users/groups/serviceaccount access to a specific resource.
- Using network policy we can control the inter pod interraction within the cluster.
```

Q: How do we implement is RBAC in Kubernetes cluster?
- First create a service account:
``` kubectl create serviceaccount my-service-account --namespace=my-namespace ```
- Then create a role where we define the rules with resources(secrets, ingress, services) and verbs (get, list)
- Then we bind the ROLE to a service account by creating a rolebinding, by mentioning the kind as service account, then name and ns of service account in the subjects. and we give reference of role (kind: Role, name and apiGroup of Role)
