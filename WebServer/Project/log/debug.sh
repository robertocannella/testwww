#!/bin/bash

source ../../env.sh


log_info() {
    if [ "$APP_INFO_MODE" != "true" ]; then
        # Debug mode is not true, so return early and don't log
        return
    fi

    # Proceed with logging
    echo "$(date): $*" >> "$INFO_LOG"
}

log_debug() {
    if [ "$APP_DEBUG_MODE" != "true" ]; then
        # Debug mode is not true, so return early and don't log
        return
    fi

    # Proceed with logging
    echo "$(date): $*" >> "$DEBUG_LOG"
}
log_error() {
    if [ "$APP_ERROR_MODE" != "true" ]; then
        # Debug mode is not true, so return early and don't log
        return
    fi

    # Proceed with logging
    echo "$(date): $*" >> "$ERROR_LOG"
}
