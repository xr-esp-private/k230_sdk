#!/usr/bin/env bash

set -euo pipefail

SDK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_REMOTE_URL="${SDK_REMOTE_URL:-https://github.com/xr-esp-private/k230_sdk}"
XRSDCARD_REMOTE_URL="${XRSDCARD_REMOTE_URL:-https://github.com/xr-esp-private/xrsdcard}"
XRSDCARD_DIR="${SDK_ROOT}/src/canmv/resources/xrsdcard"

ensure_remote_url() {
    local repo_dir="$1"
    local remote_name="$2"
    local remote_url="$3"

    if git -C "${repo_dir}" remote get-url "${remote_name}" >/dev/null 2>&1; then
        git -C "${repo_dir}" remote set-url "${remote_name}" "${remote_url}"
    else
        git -C "${repo_dir}" remote add "${remote_name}" "${remote_url}"
    fi
}

echo "Update SDK remote -> ${SDK_REMOTE_URL}"
ensure_remote_url "${SDK_ROOT}" github "${SDK_REMOTE_URL}"

if [[ -d "${XRSDCARD_DIR}/.git" ]]; then
    echo "Update xrsdcard remote -> ${XRSDCARD_REMOTE_URL}"
    ensure_remote_url "${XRSDCARD_DIR}" github "${XRSDCARD_REMOTE_URL}"
else
    echo "Clone xrsdcard -> ${XRSDCARD_DIR}"
    mkdir -p "$(dirname "${XRSDCARD_DIR}")"
    git clone "${XRSDCARD_REMOTE_URL}" "${XRSDCARD_DIR}"
fi

echo "Done."
