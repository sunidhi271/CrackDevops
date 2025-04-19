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
Q: Difference between Docker container and VM ?
```
Docker:	Shares host kernel | Starts in seconds | Lightweight
Virtual Machine: Has its own OS and kernel | Takes minutes| Heavy resource usage
```
Q: Difference between Docker volume and bind mount?
```
Ans:
Volume:	Managed by Docker | Portable across environments | -v myvol:/data
Bind Mount: Managed by USer |  Host-dependent | -v /host/path:/container/path
```
Q: What are the different Docker networking types?
Ans:
| Type	  |   Use Case                            |
|---------|---------------------------------------|
| Bridge  |	Default, good for isolated containers |
| Host	  |  Shares host’s network                |
| Overlay	| Multi-host communication (Swarm)      |
| None	  | Full network isolation                |
