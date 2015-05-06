#!/bin/sh

set -e
set -x

. /opt/sentry/bin/activate

base_dir=${base_dir-"/opt/sentry"}
cfg_dir=${cfg_dir-"${base_dir}/conf"}
log_dir=${log_dir-"/var/log/sentry"}
run=${run-'/opt/sentry/bin/supervisord'}
celerybeat_file="/var/run/sentry/celerybeat-schedule"

chown sentry: "${log_dir}"

# Set up or upgrade sentry db schema
sentry --config=${cfg_dir}/sentry.conf.py upgrade

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/sentry/bin/pip freeze

if [ ! -s "${celerybeat_file}" ]; then
    echo "$0: Creating celerybeat file ${celerybeat_file}"
    touch "${celerybeat_file}"
    chown sentry:sentry "${celerybeat_file}"
    chmod 640 "${celerybeat_file}"
fi

echo ""
echo "$0: Starting ${run}"
${run} -c /etc/supervisor.conf \
       -n

echo $0: Exiting
