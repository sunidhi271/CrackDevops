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

Q: What is the use of kubectl autoscale command ?
```
- kubectl autoscale: This command enables autoscaling for a deployment or a replica set based on avg CPU utilization by all pods.
- It allows you to dynamically adjust the number of replicas based on load.
```

Q: Write a kubectl command to autoscale a deployment from 2 to 5 replicas and set the target average CPU utilization percentage for the autoscaler to 80%.
```
k autoscale deployment grafana --min=2 max=5 --cpu-percent=80
```

Q: How to check logs of mutiple pods using one single k8s command ?
```
- We can do that if mutiple pods have same selector/labels in them using the below command as example:
kubectl logs -l run=pingpong --tail 1
- tail 1 means it shows the last line of logs of each pod.
```

Q: Run 4 replicas of elasticsearch container (image = elasticsearch:2.1) using kubectl command ?
```
kubectl run elastic --image=elasticsearch:2 --replicas=4
kubectl get pods -w
```

Q: There is a deployment named "elastic", create a default ClusterIP service exposing its port 9200 using one single kubectl command ?
```
kubectl expose deployment/elastic --port 900
```

