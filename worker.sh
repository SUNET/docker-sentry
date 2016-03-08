#!/bin/sh

set -e
set -x

. /opt/sentry/bin/activate

base_dir=${base_dir-"/opt/sentry"}
cfg_dir=${cfg_dir-"${base_dir}/conf"}
log_dir=${log_dir-"/var/log/sentry"}
run_dir=${run_dir-"/var/run/sentry"}
run=${run-'/opt/sentry/bin/sentry'}

mkdir -p "${log_dir}"
chown sentry: "${log_dir}"
mkdir -p "${run_dir}"
chown sentry:sentry "${run_dir}"

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/sentry/bin/pip freeze

echo ""
echo "$0: Starting ${run}"
cd ${run_dir}
sudo -u sentry \
    SENTRY_CONF=${cfg_dir} \
    CELERYD_PID_FILE="${run_dir}/worker.pid" \
    ${run} celery worker

echo $0: Exiting
