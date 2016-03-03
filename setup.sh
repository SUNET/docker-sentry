#!/bin/bash

set -e
set -x

apt-get clean
rm -rf /var/lib/apt/lists/*

virtualenv /opt/sentry

addgroup --system sentry
adduser --system --shell /bin/false sentry

mkdir -p /var/log/sentry
chown sentry: /var/log/sentry
chmod 770 /var/log/sentry

mkdir -p /var/run/sentry/
chown sentry: /var/run/sentry
chmod 770 /var/run/sentry

/opt/sentry/bin/pip install 'sentry[postgres]<8.3' uwsgi
/opt/sentry/bin/pip install supervisor --pre

/opt/sentry/bin/pip freeze
