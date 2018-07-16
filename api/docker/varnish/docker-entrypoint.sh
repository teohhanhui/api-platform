#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- varnishd "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'varnishd' ] && [ "$(id -u)" = '0' ]; then
	chown -R varnish:varnish .
fi

# default args
if [ "$1" = 'varnishd' ] && [ $# -eq 1 ]; then
	set -- varnishd \
		-F \
		-a :"${VARNISH_LISTEN:-80}" \
		-f "${VARNISH_VCL:-/etc/varnish/default.vcl}" \
		-s malloc,"${VARNISH_MEMORY:-100M}" \
		${VARNISH_DAEMON_OPTS:-}
fi

exec "$@"
