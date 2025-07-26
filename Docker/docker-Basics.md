#### ✅ Basics
Q: What is Docker and why is it used?
```
Ans: Docker is a containerization tool that helps package applications with all dependencies, making them portable, lightweight, and consistent across environments.
```
Q: What are the benefits of using Docker?
```
Ans:
- Lightweight and fast
- Consistent dev-to-prod environment
- Easy to scale microservices
- Faster deployments
- Environment isolation
```
Q: What is the architecture of Docker?
```
Ans:
- Docker Engine: Core service
- Docker Daemon: Runs in the background, manages containers
- Docker CLI: User interacts via commands
- REST API: Used for programmatic control
```
Q: How does Docker work under the hood?
```
Ans:
- Uses Linux namespaces for isolation
- Uses cgroups for resource limits
- Uses layered file systems
- Images are built from Dockerfiles
```
Q: How does Docker use the Linux kernel?
```
Ans:
- Uses namespaces for isolation (PID, NET, etc.)
- Uses cgroups for limiting resources
- Shares the host kernel, no OS overhead
```
Q: Can you explain what happens internally when you run docker run hello-world? What components are involved?
```
- docker run is executed by Docker CLI (client).
- The CLI sends a REST API request to the Docker Daemon (dockerd) over Unix socket (or TCP socket or /var/run/docker.sock).
- Docker Daemon checks if the hello-world image exists locally.
- If not found (first time), Docker daemon pulls it from Docker Hub (default registry).
- Docker daemon pulls the image layers from Docker Hub.
- Stores them in the local image cache (/var/lib/docker storage directory, or containerd store).
- Docker daemon creates a new container object using the hello-world image.
- Docker daemon allocates, containerID, Filesystem, Networking (bridge network by default), cgroups (for resource limits), namespaces (for isolation).
- Docker invokes containerd and runc to start the container process.
- runc creates the container using the OCI specification (Sets up namespaces and cgroups, Mounts the filesystem layers, Applies networking, Starts the container's entrypoint)
- Container process started and docker daemon captures stdout/stderr of the container process. 
```

Q: Difference between Docker container and VM ?
```
Docker:	Shares host kernel | Starts in seconds | Lightweight
Virtual Machine: Has its own OS and kernel | Takes minutes| Heavy resource usage
```
Q: Where in the linux instance are the layers of docker image cached ? 
```
/var/lib/docker/
The exact subdirectory depends on the storage driver, For most modern Linux systems (Ubuntu, RHEL, CentOS), the default is overlay2.
```
/var/lib/docker/
  ├── overlay2/          # Stores image and container layers
  ├── image/             # Metadata for images
  ├── containers/        # Container writable layers
  ├── volumes/           # Docker volumes
  ├── network/           # Network configurations


Q: Difference between Docker volume and bind mount?
```
Ans:
Volume:	Managed by Docker | Portable across environments | -v myvol:/data
Bind Mount: Managed by USer |  Host-dependent | -v /host/path:/container/path
| Feature                | **Docker Volume**                                              | **Bind Mount**                                                  |
| ---------------------- | -------------------------------------------------------------- | --------------------------------------------------------------- |
| **Location on Host**   | Stored under `/var/lib/docker/volumes/` (managed by Docker)    | Any directory on the host (`/home/user/data`, `/mnt/...`)       |
| **Management**         | Managed by Docker (can be created with `docker volume create`) | Uses an existing host directory/file                            |
| **Backup & Migration** | Easier to backup and move (portable)                           | Tightly coupled to host path – harder to migrate                |
| **Use Case**           | Persistent storage for containers (DB data, configs)           | When you want direct access to host files (code, logs, configs) |
| **Security**           | More secure – Docker controls access                           | Less secure – container has full access to host path            |
| **Portability**        | Portable across hosts if you copy `/var/lib/docker/volumes`    | Not portable – path must exist on target host                   |
| **When to Use**        | Persistent data independent of host path                       | Development where you want real-time changes                    |

```
Q: What are the different Docker networking types?
Ans:
| Type	  |   Use Case                            |                     
|---------|---------------------------------------|----------------------------------------------------------------|
| Bridge  |	Default, good for isolated containers | docker network create mynet, docker run --network mynet nginx  |
| Host	  |  Shares host’s network                | docker run --network host nginx                                |
| Overlay	| Multi-host communication (Swarm)      | docker swarm init, docker network create -d overlay myoverlay, docker service create --name web --network myoverlay nginx |
| None	  | Full network isolation                | 

Q: How overlay network works ?
- Overlay networks are designed for multi-host container communication in Docker Swarm.
- When you create an overlay network (after docker swarm init), This network is distributed across all Swarm nodes (manager + workers).
- Any container created as part of a Swarm service and attached to myoverlay can communicate with containers on other hosts using container names (DNS).
- Swarm creates a VXLAN tunnel between hosts.Overlay network provides internal DNS.Containers can ping each other by service name (e.g., ping web).
- Example:
HOST-1: Manager Node
```
docker swarm init --advertise-addr <Host1-IP>
docker network create -d overlay myoverlay
```
Host 2: Worker Node
```
docker swarm join --token <token> <Host1-IP>:2377
```
Deploy service:
```
docker service create --name web --network myoverlay --replicas 2 nginx
```
