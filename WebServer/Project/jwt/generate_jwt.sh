#!/bin/bash

source ../log/debug.sh

base64url_encode() {
    echo -n "$1" | openssl base64 -e -A | tr '+/' '-_' | tr -d '='
}

create_header() {
    local alg=${1:-HS256}
    echo -n "{\"alg\":\"$alg\",\"typ\":\"JWT\"}"
}

create_payload() {
    local sub=${1:-1234567890}
    local name=${2:-John Doe}
    local admin=${3:-true}
    echo -n "{\"sub\":\"$sub\",\"name\":\"$name\",\"admin\":$admin}"
}

sign_token() {
    local header=$1
    local payload=$2
    local secret=$3
    echo -n "$header.$payload" | openssl dgst -sha256 -hmac "$secret" -binary | openssl base64 -e -A | tr '+/' '-_' | tr -d '='
}

generate_jwt() {
    local header_payload="$1.$2"
    local secret=$3
    local signature=$(sign_token "$1" "$2" "$secret")
    echo "$header_payload.$signature" | tee -a "$DEBUG_LOG"
}

