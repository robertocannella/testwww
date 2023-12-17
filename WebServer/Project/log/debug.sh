#!/bin/bash

source ../../env.sh

log_debug() {
    if [ "$APP_DEBUG_MODE" != "true" ]; then
        # Debug mode is not true, so return early and don't log
        return
    fi

    # Proceed with logging
    echo "$(date): $*" >> "$DEBUG_LOG"
}

