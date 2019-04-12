#!/bin/sh -e
cd "$(dirname "$0")"

USAGE="
Usage:  $0 SOURCE_BUILD

Test-deploy khetha-django locally.

SOURCE_BUILD (example: 'khetha-django')
    Path to a source checkout of khetha-django to build.
"
SOURCE_BUILD="${1:?"$USAGE"}"

# Begin tracing.
set -x

export BASE_TAG='khetha-local-test:latest'

# Build
docker build \
    --build-arg DJANGO_STATICFILES_STORAGE='whitenoise.storage.CompressedManifestStaticFilesStorage' \
    --build-arg WHITENOISE_KEEP_ONLY_HASHED_FILES='True' \
    --pull  "${SOURCE_BUILD}" --tag "${BASE_TAG}"
docker-compose build --build-arg BASE_TAG

docker-compose -f docker-compose.yml -f target.local.yml up
