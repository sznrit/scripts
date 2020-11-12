#!/usr/bin/env bash
# Copyright (C) Huiqiu Zhou
#
# License: see COPYING
#
# Get latest SHA that changed contribs (needed for CI)
set -e

# Array of paths that should trigger contrib rebuilds
CONTRIB_REBUILD_PATHS=("contrib")
# Revision from which to start look for changes (backwards in time)
START_REVISION="HEAD"

# Print error message and terminate script with status 1
# Arguments:
#   Message to print
abort_err()
{
    echo "ERROR: $1" >&2
    exit 1
}

command -v "git" >/dev/null 2>&1 || abort_err "Git was not found!"

# Source root directory
SRC_ROOT_DIR=$(git rev-parse --show-toplevel)

[ -n "${SRC_ROOT_DIR}" ] || abort_err "This script must be run in the Git repo and available"
[ -f "${SRC_ROOT_DIR}/README.md" ] || abort_err "This script must be run in the Git repository"

LAST_CONTRIB_SHA=$(
    cd "$SRC_ROOT_DIR" &&
    git rev-list -1 "${START_REVISION}" -- "${CONTRIB_REBUILD_PATHS[@]}"
)

[ -n "${LAST_CONTRIB_SHA}" ] || abort_err "Failed to determine last contrib SHA using Git!"

echo "${LAST_CONTRIB_SHA}"
