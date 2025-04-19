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

