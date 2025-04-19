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

