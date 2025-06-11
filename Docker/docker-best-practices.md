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
Q: You want to reduce the image size of a Python application container that currently uses the python:3.11 base image. What steps would you take to optimize the image?
```
Ans:
- Replace python:3.11 with python:3.11-slim or even python:3.11-alpine (careful with Alpine compatibility).
- Use Muti-stage builds : Build dependencies and compile code in a first stage and Copy only necessary files into a minimal runtime stage.
- Cleanup unnecessary files: Clean up package managers caches (e.g., pip cache, apt-get clean, rm -rf /var/lib/apt/lists/*).
- Use .dockerignore file to Exclude local files (tests, docs, .git, etc.) from being copied into the image.
- Combine related RUN commands to reduce intermediate image layers.
- Prepackage dependencies and copy them directly.
- Avoid building from source during image build by using pre-built wheels.
```
