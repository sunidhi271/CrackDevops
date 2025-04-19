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
