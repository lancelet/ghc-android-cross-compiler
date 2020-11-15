#!/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir" && pwd )"

export TARGETS='x86_64-linux-android armv7-linux-androideabi aarch64-linux-android'
export NDK_HOME="${root}/ndk"
export NDK_VERSION='r21d'
export ANDROID_HOME="$NDK_HOME"  # for the toolchain-wrapper scripts
export PREFIX="${root}/deps"

./scripts/fetch-ndk.sh
./scripts/bootstrap-wrappers.sh
./scripts/init-prefix.sh
