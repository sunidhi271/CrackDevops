🎯 HELM Concepts

Q: How can you pass custom values to a Helm chart when deploying it?
```
helm template --name 123 --set .Values.key=value
```

Q: How can you use the helm template command to generate the template output of only a specific file (e.g., deployment.yaml) in the Helm chart instead of rendering the entire chart? 
```
helm template my-release ./my-chart --show-only templates/deployment.yaml
```

Q: How would you rollback a Helm release to a previous version but only modify specific resources, leaving others untouched?
```
- helm rollback my-release 2 --dry-run --output-dir ./rollback-manifests
- Then edit the specific resource(e.g, deployment.yaml)
- kubectl apply -f ./rollback-manifests/templates/deployment.yaml
```

Q: What happens if you run helm install with a release name that already exists in the cluster ?
```
Helm will throw an error, Error: cannot re-use a name that is still in use.
To upgrade or make changes on an an existing release, you should use helm upgrade.
```

Q: Can you install the same Helm chart multiple times in the same namespace?
Ans: Yes, but you must use different release names for each install.
```
helm install app1 mychart/  
helm install app2 mychart/
```

Q: What’s the difference between helm template and helm install --dry-run --debug?
```
helm template: Renders templates locally without any connection to Kubernetes cluster.
helm install --dry-run --debug: Simulates an install, rendering templates and validating them against the cluster's API (if possible). Better for debugging.
```

Q: How would you rollback a Helm release to a previous version?
```
helm rollback <release> <revision-number>
```
To get revision number,
```
helm history <release>
```

Q: What does Helm do with Secrets or ConfigMaps created in templates during helm uninstall?
```
Helm tracks all Kubernetes resources it creates using labels and annotations, so it automatically deletes them on helm uninstall. But resources created manually or outside of the chart won’t be deleted.
```

Q: What is the purpose of the _helpers.tpl file in Helm charts?
```
It's used to define template helper functions, like naming conventions, labels, or reusable snippets. You call them using {{ include "template.name" . }}.
```

Q: How can you pass environment variables to a Helm chart at install time?
```
Helm itself doesn't directly support env vars in values.yaml. But you can pass them using the shell:
helm install myapp ./chart --set image.tag=$TAG
```

Q: If you change only values.yaml, will helm diff show changes to the rendered output?
```
Yes. helm diff upgrade - compares the current release against the rendered output of the new values, so changes in values.yaml will reflect in the diff.
```
```
e.g: helm diff upgrade my-release ./my-chart --values my-values.yaml
```

 Q: What if a chart has a requirements.yaml file but no Chart.yaml dependencies block?
```
In Helm 2, requirements.yaml was used for dependencies. In Helm 3, it's deprecated in favor of declaring dependencies directly in Chart.yaml.
```
