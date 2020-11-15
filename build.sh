#!/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir" && pwd )"

export NDK_HOME="${root}/ndk"
export NDK_VERSION='r21d'

./scripts/fetch-ndk.sh
