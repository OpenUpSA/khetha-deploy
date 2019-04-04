#!/bin/sh -e
cd "$(dirname "$0")"

USAGE="
Usage:  deploy-target NAME DOCKER_HOST

Deploy khetha-django as NAME to DOCKER_HOST.

NAME  (example: 'staging')
    The name to use for the deployment instance.

DOCKER_HOST  (example: 'ssh://user@host')
    A valid DOCKER_HOST to deploy to.
"
export TARGET_NAME="${1:?"$USAGE"}"
export TARGET_DOCKER_HOST="${2:?"$USAGE"}"

test -z "${DOCKER_HOST}" || { echo "Warning, ignoring existing DOCKER_HOST for local build: ${DOCKER_HOST}"; }
unset DOCKER_HOST

# Begin tracing.
set -x

# TODO: Move to OpenUp organisation
export BASE_TAG="pidelport/khetha-deploy:${TARGET_NAME}"


# Build
docker build khetha-django --tag "${BASE_TAG}"
docker-compose build --build-arg BASE_TAG

# Push
docker push "${BASE_TAG}"
docker-compose push

# Deploy
DOCKER_HOST="$TARGET_DOCKER_HOST" docker stack deploy -c docker-compose.yml -c "target.${TARGET_NAME}.yml" "khetha-${TARGET_NAME}"
