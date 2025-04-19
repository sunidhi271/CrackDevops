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
