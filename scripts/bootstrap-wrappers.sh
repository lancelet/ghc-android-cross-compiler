#!/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir/.." && pwd )"
readonly wrapper_dir="$( cd "$root/toolchain-wrapper" && pwd )"

readonly default_targets='x86_64-linux-android armv7-linux-androideabi aarch64-linux-android'
readonly targets=${TARGETS:-"${default_targets}"}
readonly commands='clang ld ld.gold nm ar ranlib cabal llvm-dis llvm-nm llvm-ar'

echo "Step: Bootstrapping toolchain-wrappers for targets: ${targets}"

pushd "${wrapper_dir}" >/dev/null
for target in $targets; do
    for command in $commands; do
        if [ ! -e "$target-$command" ]; then
            echo "Creating $target-$command"
            ln -s wrapper "$target-$command"
        else
            echo "$target-$command already exists - done."
        fi
    done
    if [ ! -e "$target-libtool" ]; then
        echo "Creating $target-libtool"
        ln -s libtool-lite "$target-libtool"
    else
        echo "$target-libtool already exists - done."
    fi
done
popd >/dev/null
