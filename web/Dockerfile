# Image for the khetha-django web server.
#
# This is implemented with an NGINX config that serves the static files,
# and proxies through to the WSGI server.


# XXX: Work around lack of interpolation in "COPY --from".
# See upstream issues:
# https://github.com/moby/moby/issues/35018
# https://github.com/docker/cli/issues/996
ARG BASE_TAG
FROM ${BASE_TAG} AS base-tag


FROM nginx:alpine
COPY --from=base-tag /static_root/ /static_root/
COPY nginx.conf /etc/nginx/conf.d/default.conf
