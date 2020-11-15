#!/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir/.." && pwd )"

readonly prefix="${PREFIX:-"${root}/deps"}"

echo "Step: Initialize built binary prefix: ${prefix}"
if [ -d "${prefix}" ]; then
    echo "Build prefix exists already - done."
else
    mkdir -p "${prefix}"
fi
