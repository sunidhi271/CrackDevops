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
Ans:
# To delete all resources unused images/containers/networks excluding volumes: docker system prune -a 
# To delete every unsed resources: docker system prune --volumes
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

Q: How to override the entrypoint ?
```
- ENTRYPOINT can only be overridden with --entrypoint.
- If ENTRYPOINT is shell form, Docker wraps it in /bin/sh -c.

# Dockerfile
FROM ubuntu
ENTRYPOINT ["echo"]
CMD ["Hello"]

# Command to override entrypoint, echo with ls
docker run --entrypoint ls myimage

# Command to override cmd
docker run myimage Hi

# Command to override both entrypoint and cmd
docker run --entrypoint ls myimage
```

Q: What happens when CMD and Entrypoint is not there ?
✅ If **both missing** → Inherit from base image.  
✅ If base also missing → Error: *No command specified*.  
✅ `--entrypoint` overrides ENTRYPOINT.  
✅ Args after image name override CMD.  

| Case | ENTRYPOINT | CMD | Final Command Executed | Notes |
|------|------------|-----|------------------------|--------|
| 1 | ❌ None | ✅ Present | CMD as command | `CMD ["echo","Hello"]` → `echo Hello` |
| 2 | ✅ Present | ❌ None | ENTRYPOINT only | `ENTRYPOINT ["echo"]` → runs `echo` (no args) |
| 3 | ✅ Present | ✅ Present | ENTRYPOINT + CMD as args | `ENTRYPOINT ["echo"]`, `CMD ["Hello"]` → `echo Hello` |
| 4 | ✅ Present | ✅ Present | Override CMD | `docker run myimage Hi` → `echo Hi` |
| 5 | ✅ Present | ✅ Present | Override ENTRYPOINT | `docker run --entrypoint ls myimage /` → `ls /` |
| 6 | ❌ None | ❌ None | Inherits from base image | If base image defines CMD/ENTRYPOINT → uses that; else error |
| 7 | Base image has CMD | ❌ None | Uses base image CMD | `FROM ubuntu` → default CMD = `/bin/bash` |
| 8 | Base image has ENTRYPOINT+CMD | ❌ None | Uses both from base | `FROM nginx` → runs nginx normally |
| 9 | Override ENTRYPOINT only | --entrypoint used | Still uses CMD unless args passed | `docker run --entrypoint ls myimage` → `ls Hello` (if CMD=Hello) |
