#!/bin/sh -ex
cd "$(dirname "$0")"

export BASE_TAG='khetha-local-test:latest'

# Build
docker build \
    --build-arg DJANGO_STATICFILES_STORAGE='whitenoise.storage.CompressedManifestStaticFilesStorage' \
    --build-arg WHITENOISE_KEEP_ONLY_HASHED_FILES='True' \
    --pull  "${SOURCE_BUILD}" --tag "${BASE_TAG}"
docker-compose build --build-arg BASE_TAG

docker-compose -f docker-compose.yml -f target.local.yml up
