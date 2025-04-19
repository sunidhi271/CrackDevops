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
