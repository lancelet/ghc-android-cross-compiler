#!/usr/bin/env bash
set -euo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly root="$( cd "$dir/.." && pwd )"

readonly ndk_home=${NDK_HOME:-"${root}/ndk"}
readonly ndk_version=${NDK_VERSION:-'r21d'}

echo "Step: Downloading NDK (Android Native Development Kit) to ${ndk_home}"

if [ -d "${ndk_home}" ]; then
    echo "${ndk_home} already exists - done."
else
    readonly android_repo='https://dl.google.com/android/repository'
    readonly ndk_url="${android_repo}/android-ndk-${ndk_version}-darwin-x86_64.zip"
    echo "Downloading ${ndk_url} and extracting to ${ndk_home}..."
    mkdir -p "${ndk_home}"
    curl -L "${ndk_url}" | tar x --directory="${ndk_home}" --strip-components=1
    echo "Completed extracting ${ndk_home}"
fi
