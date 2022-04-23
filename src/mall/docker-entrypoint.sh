#!/usr/bin/env sh
set -eu

envsubst '${SVC_PRODUCT} ${SVC_PASSPORT}' < /etc/nginx/conf.d/mall-all.template > /etc/nginx/conf.d/mall-all.conf

exec "$@"