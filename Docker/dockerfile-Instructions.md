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
Q: Can environment variables defined in a Dockerfile be overridden at runtime and during build time ?
```
Ans:
Inside Dockerfile define the variable - ENV APP_MODE=production
In docker command to override ENV variable during runtime: docker run -e APP_MODE=development my-image

Env variables can not be overriden during build time. However, ARG defined in Dockerfile can be overriden.
ARG APP_MODE=production
ENV APP_MODE=${APP_MODE}
During build time override the ARG - docker build --build-arg APP_MODE=development .
```

Q: COPY vs ADD in Dockerfile?
```
Ans:
COPY: Basic file/folder copy
ADD: Extra features – extract .tar, download URLs
```
