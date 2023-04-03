# Debug Image

Image containing various debugging tools.

## Usage with Kubernetes

### Start debugging Pod using kubectl exec

```bash
kubectl run -i --tty --rm debug --image=simonmwessel/debug:latest --restart=Never -- /bin/bash
```

### Start debugging Pod using manifest

If you want to keep the Pod runnning or need to attach further configurations, you may use a manifest to create the Pod.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
spec:
  containers:
  - image: docker.io/simonmwessel/debug:latest
    imagePullPolicy: IfNotPresent
    name: debug-pod
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "trap : TERM INT; sleep 9999999999d & wait" ] # Keep Pod alive until delete/kill
  restartPolicy: Never
  # Optional: Schedule Pod to specific node
  # nodeName: mynode
```

```bash
# Apply Pod
kubectl apply -n mynamespace -f manifest.yaml
# Open shell on Pod
kubectl exec -n mynamespace --stdin --tty debug-pod -- /bin/bash
```
