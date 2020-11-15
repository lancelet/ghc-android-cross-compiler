#/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir" && pwd )"

export NDK_HOME="${root}/ndk"
export PREFIX="${root}/deps"

echo "Cleaning"

echo "Removing ndk directory"
rm -rf "$NDK_HOME"

echo "Resetting toolchain-wrapper"
pushd toolchain-wrapper >/dev/null
git reset --hard
popd >/dev/null

echo "Removing build prefix"
rm -rf "$PREFIX"
