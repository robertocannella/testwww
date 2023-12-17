#!/bin/bash

source ../../env.sh

log_debug() {
    echo "$(date): $@" >> "$DEBUG_LOG"
}
