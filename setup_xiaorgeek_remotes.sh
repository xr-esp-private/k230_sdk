#!/usr/bin/env bash

set -euo pipefail

SDK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_REMOTE_URL="${SDK_REMOTE_URL:-https://github.com/xr-esp-private/k230_sdk}"
XRSDCARD_REMOTE_URL="${XRSDCARD_REMOTE_URL:-https://github.com/xr-esp-private/xrsdcard}"
XRSDCARD_DIR="${SDK_ROOT}/src/canmv/resources/xrsdcard"
LOCAL_MANIFEST_DIR="${SDK_ROOT}/.repo/local_manifests"
LOCAL_MANIFEST_FILE="${LOCAL_MANIFEST_DIR}/xiaorgeek.xml"
LOCAL_MANIFEST_TEMPLATE="${SDK_ROOT}/tools/xiaorgeek-local-manifest.xml.template"
SDK_PROJECT_PATH="${SDK_REMOTE_URL#https://github.com/}"
XRSDCARD_PROJECT_PATH="${XRSDCARD_REMOTE_URL#https://github.com/}"
SDK_PROJECT_PATH="${SDK_PROJECT_PATH%.git}"
XRSDCARD_PROJECT_PATH="${XRSDCARD_PROJECT_PATH%.git}"
SDK_REVISION="${SDK_REVISION:-main}"
XRSDCARD_REVISION="${XRSDCARD_REVISION:-main}"

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

write_local_manifest() {
    mkdir -p "${LOCAL_MANIFEST_DIR}"
    sed \
        -e "s|__SDK_PROJECT__|${SDK_PROJECT_PATH}|g" \
        -e "s|__XRSDCARD_PROJECT__|${XRSDCARD_PROJECT_PATH}|g" \
        -e "s|__SDK_REVISION__|${SDK_REVISION}|g" \
        -e "s|__XRSDCARD_REVISION__|${XRSDCARD_REVISION}|g" \
        "${LOCAL_MANIFEST_TEMPLATE}" > "${LOCAL_MANIFEST_FILE}"
}

echo "Update SDK remote -> ${SDK_REMOTE_URL}"
ensure_remote_url "${SDK_ROOT}" github "${SDK_REMOTE_URL}"

echo "Write repo local manifest -> ${LOCAL_MANIFEST_FILE}"
write_local_manifest

if [[ -d "${XRSDCARD_DIR}/.git" ]]; then
    echo "Update xrsdcard remote -> ${XRSDCARD_REMOTE_URL}"
    ensure_remote_url "${XRSDCARD_DIR}" github "${XRSDCARD_REMOTE_URL}"
else
    echo "Clone xrsdcard -> ${XRSDCARD_DIR}"
    mkdir -p "$(dirname "${XRSDCARD_DIR}")"
    git clone "${XRSDCARD_REMOTE_URL}" "${XRSDCARD_DIR}"
fi

echo "Done."
