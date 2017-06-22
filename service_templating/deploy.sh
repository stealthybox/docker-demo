#!/bin/sh
docker stack rm mounts
sleep 4
docker deploy -c stack.yml mounts

sleep 2
docker service inspect --pretty mounts_hello
docker service ps --no-trunc mounts_hello
sleep 2
docker service logs mounts_hello
