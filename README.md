# Debug Image
<img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/simon-wessel/debug-image/docker-image.yml"> <img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/simonmwessel/debug"> <img alt="Docker Image Size (latest by date)" src="https://img.shields.io/docker/image-size/simonmwessel/debug">

![](images/debug_image_logo.jpg)

Image containing various debugging tools.
This image is more focused on the availability of tools than on its size.

## Usage with Kubernetes

### Start debugging Pod using kubectl exec

```bash
kubectl run -i --tty --rm debug --image=simonmwessel/debug:latest --image-pull-policy=Always --restart=Never -- /bin/zsh
```

### Start debugging Pod using manifest

If you want to keep the Pod runnning or need to attach further configurations, you may use a manifest to create the Pod.

#### Regular Pod manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
spec:
  containers:
  - image: docker.io/simonmwessel/debug:latest
    imagePullPolicy: Always
    name: debug-pod
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "trap : TERM INT; sleep 1d & wait" ] # Keep Pod alive for 1 day or until delete/kill
  restartPolicy: Never
  # Optional: Schedule Pod to specific node
  # nodeName: mynode
```

#### Pod manifest for namespaces with Pod Security Standards

This manifest can be used in namespaces that have pod security standard restrictions.
The user in the pod will be a non-root user.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
spec:
  securityContext:
    fsGroup: 1000
    fsGroupChangePolicy: "OnRootMismatch"
    runAsNonRoot: true
    runAsUser: 1000
  containers:
  - image: docker.io/simonmwessel/debug:latest
    imagePullPolicy: Always
    name: debug-pod
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "trap : TERM INT; sleep 1d & wait" ] # Keep Pod alive for 1 day or until delete/kill
    securityContext:
      allowPrivilegeEscalation: false
      seccompProfile:
        type: RuntimeDefault
      capabilities:
        drop:
        - ALL
  restartPolicy: Never
  # Optional: Schedule Pod to specific node
  # nodeName: mynode
```

### Apply pod and open shell

```bash
# Apply Pod
kubectl apply -n mynamespace -f manifest.yaml
# Open shell on Pod
kubectl exec -n mynamespace --stdin --tty debug-pod -- /bin/zsh
```
