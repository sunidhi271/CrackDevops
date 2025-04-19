# 🐳 Docker – DevOps Interview Prep

📚 Table of Contents
-  Basics
-  Dockerfile Instructions 
-  Docker Best Practices
-  Questions to check Hands-on experience 


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


#### 🌿 Dockerfile Instructions 
Q: What is the difference between CMD and ENTRYPOINT in Dockerfile?
```
Ans:
- CMD	ENTRYPOINT
- Default command	Main application
- Overridable at runtime	Not easily overridden unless forced
- Replaced if args are passed	Args are appended to ENTRYPOINT
```
Q: Difference between ENV and ARG in Dockerfile?
```
Ans:
ENV	: Available at runtime	| Can be overridden via run
ARG : Available only at build time | Used with build --build-arg
```
Q: COPY vs ADD in Dockerfile?
```
Ans:
COPY: Basic file/folder copy
ADD: Extra features – extract .tar, download URLs
```
Q: What are the different Docker networking types?
Ans:
| Type	  |   Use Case                            |
|---------|---------------------------------------|
| Bridge  |	Default, good for isolated containers |
| Host	  |  Shares host’s network                |
| Overlay	| Multi-host communication (Swarm)      |
| None	  | Full network isolation                |



#### 🧱 Docker Best Practices
Q: What is a multistage Docker build? 
```
Ans: A multistage Docker build is a Dockerfile technique where you use multiple FROM statements to define different stages in the build process.
This reduces the final image size and attack surface, so increases security. 
Stage 1: You build a big image with all the tools needed to build your app (like compilers, dependencies, etc.).
Stage 2: You copy only the final result (your built app) into a small clean image.
```
Example:
```
FROM golang:1.21 AS builder
WORKDIR /app
COPY ..
RUN go build -o myapp

FROM alpine:latest
COPY --from=builder /app/myapp /test
ENTRYPOINT ["/test"]
```
Q: How do you optimize Docker images?
```
Ans:
- Use minimal base images like Alpine
- Combine RUN instructions
- Use multistage builds
- Remove unnecessary files
```
Q: Docker security best practices?
```
Ans:
- Use trusted base images
- Scan images for vulnerabilities
- Drop unnecessary container privileges
- Use COPY over ADD
```

#### 📝 Questions to check Hands-on experience 
Q: How to write a basic Dockerfile to print "Hello World"?
Ans: 
Dockerfile:
```
FROM alpine
CMD echo "Hello World"
```
Commands to build and run:
```
docker build -t hello .
docker run hello
```
Q: How do you expose container ports to host?
```
Ans: docker run -p 8080:80 nginx
```
Q: How to stop all containers?
```
Ans: docker stop $(docker ps -q)
```
Q: How to prune unused resources?
```
Ans: docker system prune --volumes
```
Q: How to remove all images?
```
docker rmi $(docker images -aq)
```
Q: How to copy a file into a container?
```
Ans: docker cp file.txt my_container:/app/
```
Q: How to check Docker service status?
```
Ans: systemctl status docker
```
Q: How to use secrets securely during build?
```
Ans: Docker has BuildKit which allows using secrets securely during build time.
DOCKER_BUILDKIT=1 docker build --secret id=mysecret,src=secret.txt .

Dockerfile:
FROM alpine
RUN --mount=type=secret,id=mysecret,target=/etc/secret \
              cat /etc/secret
```
Q: Write a docker commands to curl Nginx container from another container on same network?
```
Ans: 
docker network create test_bridge
docker run -d --name nginx --network test_bridge -p 8080:80 nginx
docker run -it --network test_bridge alpine sh -c "apk add curl && curl http://nginx"
```
