#!/usr/bin/env bash

set -euo pipefail

SDK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${SDK_ROOT}/.venv"
WORK_HOME="${WORK_HOME:-${HOME}}"
DEFAULT_DEFCONFIG="k230_canmv_xiaorgeek_defconfig"
DEFCONFIG="${1:-${DEFAULT_DEFCONFIG}}"
TARGET="${2:-log}"
PYTHON_VERSION="$("${VENV_DIR}/bin/python" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"

export PATH="${VENV_DIR}/bin:${WORK_HOME}/.bin:${PATH}"
export HOME="${WORK_HOME}"

if [[ -n "${PYTHON_VERSION}" ]]; then
    export SCONS_LIB_DIR="${VENV_DIR}/lib/python${PYTHON_VERSION}/site-packages/scons"
fi

if [[ ! -d "${VENV_DIR}" ]]; then
    echo "Missing virtualenv: ${VENV_DIR}"
    echo "Create it first and install python deps."
    exit 1
fi

if [[ ! -d "${HOME}/.kendryte/k230_toolchains" ]]; then
    echo "Missing toolchains under ${HOME}/.kendryte/k230_toolchains"
    echo "Run: make dl_toolchain"
    exit 1
fi

if [[ ! -f "${SDK_ROOT}/configs/${DEFCONFIG}" ]]; then
    echo "Unknown defconfig: ${DEFCONFIG}"
    echo "Available examples:"
    ls "${SDK_ROOT}/configs" | sed -n '1,20p'
    exit 1
fi

cd "${SDK_ROOT}"

echo "Using SDK root: ${SDK_ROOT}"
echo "Using defconfig: ${DEFCONFIG}"
echo "Using target: ${TARGET}"

make "${DEFCONFIG}"
time make "${TARGET}"
