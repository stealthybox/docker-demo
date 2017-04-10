This repo contains useful things for playing with Docker Swarm Mode.

There is automation here for running a swarm with multiple hosts on a single machine using containers as managers and workers.

There are also several stack files which serve as a starting point for understanding the scheduler and playing with different use-cases.


# Running a Swarm in Containers
```bash
cd swarm
source start
```
This exports some environment vars into your shell.
If you are already part of a swarm, ignore the error.
```bash
docker stack up admin -c ../admin/docker-compose.yaml
# alternatively, `cd ../admin && docker-compose up -d`
```
In a few moments, you should see a visualization @ [localhost:8090](http://localhost:8090) showing your host and any swarm services.
```bash
docker-compose up -d worker
# you should see a worker node join the swarm
docker-compose scale worker=4
# 3 more should join in a few seconds
```
You now have a multi-host swarm that you can play around in.
For speed, configure your docker engine to use:
```json
"registry-mirrors": [
  "http://localhost:5000"
]
```
When you're done, `cd swarm && ./kill`.
You may need to run `./kill` more than once.

## Some Helpful Commands
```
export DOCKER_HIDE_LEGACY_COMMANDS=true
docker --help
docker node ls
docker node --help
docker stack ls
docker stack --help
docker service ls
docker service --help
docker service inspect <SERVICE> --pretty
```

## How it Works
The `start` script:
- ensures a swarm exists
- exports the join tokens as env vars
- exports the `{{.Swarm.NodeAddr}}` as `$HOST_IP`

`swarm/docker-compose.yaml` depends on these env vars.
It contains services for managers and workers.
These services run **docker in docker** (`dind`) as priviledged containers on the host.
The `entrypoint` is overridden to run an inline shell script that:
- starts the container's `dockerd` with overlay2 and the `admin_mirror`
- traps interrupts
- waits until `docker info` succeeds
- joins the host's swarm with the service's `$TOKEN`

You can classify nodes by adding `--label` flags to the `$opts`.
These are engine labels which shouldn't be confused with swarm node labels.

# Using Stacks
Stack files allow you to use the [docker-compose schema](https://docs.docker.com/compose/compose-file/) to declare a desired state for many related services.
These services will achieve their desired state through the swarm scheduler.

This repo contains a few different stack files that demonstrate neat use cases.

You can deploy a stack by running:
```bash
docker stack up -c stack_name/docker-compose.yaml stack_name
```
You can change the file and run the command again to watch swarm remediate the state.

The **admin** stack is recommended since it runs services that help you understand and speed up what you are doing.

Try the **minio** stack if you want to play with a self-hosted, distributed, S3 compatible object store.

The **routing** stack is great for trying `traefik`, a dynamically configured load-balancer.