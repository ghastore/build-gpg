#!/bin/bash -e

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

# Vars.
GIT_REPO="${1}"
GIT_USER="${2}"
GIT_EMAIL="${3}"
GIT_TOKEN="${4}"
GPG_URL="${5}"
GPG_NAME="${6}"

# Apps.
date="$( command -v date )"
git="$( command -v git )"
curl="$( command -v curl )"
gpg="$( command -v gpg )"
ts="$( _timestamp )"

# Dirs.
d_src="/root/git/repo"

# Git config.
${git} config --global user.name "${GIT_USER}"
${git} config --global user.email "${GIT_EMAIL}"
${git} config --global init.defaultBranch 'main'

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  git_clone \
    && gpg_build \
    && git_push
}

# -------------------------------------------------------------------------------------------------------------------- #
# GIT: CLONE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

git_clone() {
  echo "--- [GIT] CLONE: ${GIT_REPO#https://}"

  local SRC="https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO#https://}"

  ${git} clone "${SRC}" "${d_src}"

  echo "--- [GIT] LIST: '${d_src}'"
  ls -1 "${d_src}"
}

# -------------------------------------------------------------------------------------------------------------------- #
# GPG: BUILD FILES.
# -------------------------------------------------------------------------------------------------------------------- #

gpg_build() {
  echo "--- [GPG] BUILD"
  _pushd "${d_src}" || exit 1

  ${curl} -fsSL "${GPG_URL}" | ${gpg} --dearmor -o "${GPG_NAME}"

  _popd || exit 1
}

# -------------------------------------------------------------------------------------------------------------------- #
# GIT: PUSH PACKAGE TO PACKAGE STORE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

git_push() {
  echo "--- [GIT] PUSH: '${d_src}' -> '${GIT_REPO#https://}'"
  _pushd "${d_src}" || exit 1

  # Commit build files & push.
  echo "Commit build files & push..."
  ${git} add . \
    && ${git} commit -a -m "BUILD: ${ts}" \
    && ${git} push

  _popd || exit 1
}

# -------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------< COMMON FUNCTIONS >------------------------------------------------ #
# -------------------------------------------------------------------------------------------------------------------- #

# Pushd.
_pushd() {
  command pushd "$@" > /dev/null || exit 1
}

# Popd.
_popd() {
  command popd > /dev/null || exit 1
}

# Timestamp.
_timestamp() {
  ${date} -u '+%Y-%m-%d %T'
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
