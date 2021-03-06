#!/bin/sh -e
cd "$(dirname "$0")"

USAGE="
Usage:  deploy-target NAME DOCKER_HOST [SOURCE_BUILD]

Deploy khetha-django as NAME to DOCKER_HOST.

NAME  (example: 'staging')
    The name to use for the deployment instance.

DOCKER_HOST  (example: 'ssh://user@host')
    A valid DOCKER_HOST to deploy to.

SOURCE_BUILD (optional, example: 'khetha-django')
    Path to a source checkout of khetha-django to build.
"
TARGET_NAME="${1:?"$USAGE"}"
TARGET_DOCKER_HOST="${2:?"$USAGE"}"
SOURCE_BUILD="${3}"

# Begin tracing.
set -x

# Base repo / tag to save the deployment images to.
# TODO: Move to OpenUp organisation
export BASE_TAG="${BASE_TAG:-"pidelport/khetha-deploy:${TARGET_NAME}"}"


# Build or pull BASE_TAG
if test -n "${SOURCE_BUILD}"; then
    echo "Building ${BASE_TAG} from ${SOURCE_BUILD}"
    docker build \
        --build-arg DJANGO_STATICFILES_STORAGE='whitenoise.storage.CompressedManifestStaticFilesStorage' \
        --build-arg WHITENOISE_KEEP_ONLY_HASHED_FILES='True' \
        --pull "${SOURCE_BUILD}" --tag "${BASE_TAG}"
else
    SOURCE_TAG='pidelport/khetha-django:latest'  # XXX: Hard-coded stable source for now.
    echo "Pulling ${BASE_TAG} from ${SOURCE_TAG}"
    docker pull "${SOURCE_TAG}"
    docker tag "${SOURCE_TAG}" "${BASE_TAG}"
fi
# Build deployment images from BASE_TAG
docker-compose build --build-arg BASE_TAG

# Push
docker push "${BASE_TAG}"
docker-compose push

# Deploy
DOCKER_HOST="$TARGET_DOCKER_HOST" docker stack deploy -c docker-compose.yml -c "target.${TARGET_NAME}.yml" "khetha-${TARGET_NAME}"
