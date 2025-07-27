Q: Your deployment is failing after rollout. How do you rollback?
```
kubectl rollout undo deployment <name>
If you want to rollback the helm chart: helm rollback <release name> <revision>
```
Q: Pods are not scheduling on a node. How to debug?
```
1. Check nodeSelctor in pod: kubectl describe <podname>
2. check node labels: kubectl get nodes --show-labels
3. check whether any taint is applied on Node
4. check the node is scheduled properly or not: k get nodes -o wide
```

Q: Prometheus is not scraping metrics from a pod. How will you troubleshoot?

Q: A developer accidentally deleted a K8s namespace – how would you recover?
```
1. If namespace is still in terminating state, take backup of everything:
- kubectl get all --namespace=<namespace> -o yaml > backup.yaml
- kubectl get pvc,pv,secrets,configmaps --namespace=<namespace> -o yaml >> backup.yaml
2. If namespace is already deleted:
- If gitops is applied via Argocd, then create the namespace and sync all the argocd apps, so that it will reapply all the deleted resources.
- If periodic backup is taken using toold like Velero then restore the backup.
- Restore etcd snapshot to previous state (usually done by cluster admin).

Preventive Actions:
- Use RBAC to prevent accidental deletion.
- Use OPA Gatekeeper / Kyverno policies to block kubectl delete namespace unless approved.
- Use GitOps → cluster state is always re-applied from Git.
```

