#!/usr/bin/env bash

set -euo pipefail

SDK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${SDK_ROOT}/.venv"
WORK_HOME="${WORK_HOME:-${HOME}}"
SOURCE_DEFCONFIG="${1:-k230_canmv_yahboom_defconfig}"
TARGET_DEFCONFIG="${2:-k230_canmv_xiaorgeek_defconfig}"
TARGET_BUILD_DIR="${SDK_ROOT}/output/${TARGET_DEFCONFIG}"
TARGET_IMAGES_DIR="${TARGET_BUILD_DIR}/images"

export PATH="${VENV_DIR}/bin:${WORK_HOME}/.bin:${PATH}"
export HOME="${WORK_HOME}"
export SDK_BUILD_IMAGES_DIR="${TARGET_IMAGES_DIR}"
set +u
source "${SDK_ROOT}/.config"
set -u

SOURCE_IMAGES_DIR="${SDK_ROOT}/output/${SOURCE_DEFCONFIG}/images"

required_source_dirs=(
    "${SOURCE_IMAGES_DIR}/bin"
    "${SOURCE_IMAGES_DIR}/uboot"
    "${SOURCE_IMAGES_DIR}/opensbi"
    "${SOURCE_IMAGES_DIR}/rtapp"
    "${SOURCE_IMAGES_DIR}/rtsmart"
)

for dir in "${required_source_dirs[@]}"; do
    if [[ ! -d "${dir}" ]]; then
        echo "Missing Yahboom reference artifacts: ${dir}"
        exit 1
    fi
done

mkdir -p "${TARGET_IMAGES_DIR}"

for name in bin uboot opensbi rtapp rtsmart; do
    echo "Overlay ${name} from ${SOURCE_DEFCONFIG} -> ${TARGET_DEFCONFIG}"
    rm -rf "${TARGET_IMAGES_DIR:?}/${name}"
    rsync -aq "${SOURCE_IMAGES_DIR}/${name}/" "${TARGET_IMAGES_DIR}/${name}/"
done

find "${TARGET_BUILD_DIR}" -maxdepth 1 -type f \
    \( -name '*.img' -o -name '*.img.gz' -o -name '*.img.gz.md5' -o -name '*.kdimg' -o -name '*.kdimg.gz' \) \
    -delete

export SDK_SRC_ROOT_DIR="${SDK_ROOT}"
export SDK_TOOLS_DIR="${SDK_ROOT}/tools"
export SDK_BOARDS_DIR="${SDK_ROOT}/boards"
export SDK_BOARD_DIR="${SDK_BOARDS_DIR}/${CONFIG_BOARD}"
export SDK_BUILD_DIR="${TARGET_BUILD_DIR}"
export SDK_BUILD_IMAGES_DIR="${TARGET_IMAGES_DIR}"
export SDK_RTSMART_SRC_DIR="${SDK_ROOT}/src/rtsmart"
export SDK_CANMV_SRC_DIR="${SDK_ROOT}/src/canmv"
export MK_IMAGE_NAME="${CONFIG_BOARD_NAME}"

echo "Repackaging final XIAORGEEK image with Yahboom bootchain"
"${SDK_ROOT}/tools/gen_image.sh"
