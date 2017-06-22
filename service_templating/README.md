# Service Templates
This stack is currently a valuable example of using Go Templates to modify the ContainerSpec of a swarm service from a stack file.  
At this point in time, you can template `.Service`, `.Task`, and `.Node` information into `.Hostname`, `.Env`, and `.Mounts`.  
See the Docker docs on this [here](https://docs.docker.com/engine/reference/commandline/service_create/#create-services-using-templates).  

### volumes:
There are some caveats with using templating in mount specs with stack files.
There are issues like [this one](https://github.com/moby/moby/issues/30770#issuecomment-277874145) related to using volumes names.
Bind mounts work well without modification.
See `stack.yml` for more context.

### usage:
```bash
mkdir 1 2 3
touch 1/a 2/a 3/a
docker deploy -c stack.yml mounts
docker service logs -f mounts_hello
```
```
mounts_hello.3.7hlgvxpla3f6@moby    | hi! im hello-3, task-3 of mounts_hello in stack: mounts
mounts_hello.1.cxkdeu4jhg1n@moby    | hi! im hello-1, task-1 of mounts_hello in stack: mounts
mounts_hello.2.x7yt0o0g5he5@moby    | hi! im hello-2, task-2 of mounts_hello in stack: mounts
mounts_hello.2.x7yt0o0g5he5@moby    | total 0
mounts_hello.3.7hlgvxpla3f6@moby    | total 0
mounts_hello.1.cxkdeu4jhg1n@moby    | total 0
mounts_hello.2.x7yt0o0g5he5@moby    | -rwxr-xr-x    1 root     root             0 Jun 22 05:29 b
mounts_hello.1.cxkdeu4jhg1n@moby    | -rwxr-xr-x    1 root     root             0 Jun 22 05:29 a
mounts_hello.3.7hlgvxpla3f6@moby    | -rwxr-xr-x    1 root     root             0 Jun 22 05:29 c
```

# scripts
`deploy.sh` removes shrapnel and prints out helpful information.  
`service.sh` creates a similar service to the stackfile from the command line.  
You may need to run these scripts 2-3 times depending on how slow your swarm is. (because removal is async)
