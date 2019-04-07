# Image for the khetha-django WSGI server.

ARG BASE_TAG
FROM ${BASE_TAG}

RUN pip install --no-cache --user gunicorn
# XXX: Just run django-admin migrate here, for now.
# TODO: Better bind host?
CMD django-admin migrate --noinput && gunicorn --bind 0.0.0.0 'django.core.wsgi:get_wsgi_application()'
