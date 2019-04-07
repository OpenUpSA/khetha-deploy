#!/bin/sh -ex
cd "$(dirname "$0")"

export BASE_TAG='khetha-local-test:latest'

# Build
docker build khetha-django --tag "${BASE_TAG}"
docker-compose build --build-arg BASE_TAG

docker-compose -f docker-compose.yml -f target.local.yml up
