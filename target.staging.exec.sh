#!/bin/sh -e
#
# Execute a command (such as django-admin) in the staging WSGI container.
#
# To increase the interactivity of this, you can run a background tunnel: ssh -MN root@178.128.143.69

export DOCKER_HOST='ssh://root@178.128.143.69'

CONTAINER_ID="$(docker ps --filter label=com.docker.swarm.service.name=khetha-staging_wsgi --quiet)"
# XXX: Some command invocations expect -t here, some not: adjust as necessary.
docker exec -i "${CONTAINER_ID}" "${@:-"sh"}"
