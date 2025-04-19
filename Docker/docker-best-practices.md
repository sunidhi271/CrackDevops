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
