#!/bin/sh
docker service rm hello
docker service create --detach=true \
  --name hello \
  --hostname 'hello-{{.Task.Slot}}' \
  --env SLOT='{{.Task.Slot}}' \
  --env SERVICE='{{.Service.Name}}' \
  --replicas 3 \
  --mount \
  'type=bind,src=//local/mounts/{{.Task.Slot}},target=/data' \
  alpine \
  sh -c '
    echo hi! im ${HOSTNAME}, task-${SLOT} of ${SERVICE}
    ls -l /data
    sleep 1000
  '

sleep 2
docker service inspect --pretty hello
docker service ps --no-trunc hello
docker service logs hello
