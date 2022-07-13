#!/bin/bash

set -o errexit

CMD="/usr/bin/imapfilter"
ARGS=""

if [[ -n $IMAPFILTER_CONFIG_DIR ]];then
    export IMAPFILTER_HOME=$IMAPFILTER_CONFIG_DIR
fi

if [[ -n $IMAPFILTER_CONFIG ]];then
    ARGS="-c $IMAPFILTER_CONFIG "
fi

if [[ -n $IMAPFILTER_VERBOSE ]];then
    ARGS="$ARGS -v "
fi

if [[ -n $IMAPFILTER_DEBUG_FILE ]];then
    ARGS="$ARGS -d $IMAPFILTER_DEBUG_FILE "
fi

if [[ -n $IMAPFILTER_DRY_RUN ]];then
    ARGS="$ARGS -n "
fi

if [[ -n $IMAPFILTER_EXTRA_ARGS ]];then
    ARGS="$ARGS $IMAPFILTER_EXTRA_ARGS "
fi

exec 3>&1

# https://www.linuxjournal.com/content/bash-redirections-using-exec
if [[ -n $IMAPFILTER_LOG_DIR ]];then
    npipe_stdout=/tmp/imapfilter-stdout-$$-${RANDOM}.tmp
    npipe_stderr=/tmp/imapfilter-stderr-$$-${RANDOM}.tmp
    mknod $npipe_stdout p
    mknod $npipe_stderr p

    echo "Redirecting stdout to ${IMAPFILTER_LOG_DIR}/imapfilter-stdout.log"
    echo "Redirecting stderr to ${IMAPFILTER_LOG_DIR}/imapfilter-errors.log"
    ts "%Y-%m-%d %H:%M:%S: " <$npipe_stdout >> ${IMAPFILTER_LOG_DIR}/imapfilter-stdout.log &
    ts "%Y-%m-%d %H:%M:%S: " <$npipe_stderr >> ${IMAPFILTER_LOG_DIR}/imapfilter-errors.log &

    exec 1>&-
    exec 1>$npipe_stdout
    exec 2>&-
    exec 2>$npipe_stderr
fi

echo "Running: $CMD $ARGS" >&3
exec $CMD $ARGS
