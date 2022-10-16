#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#
# This file is part of the xPack distribution.
#   (https://github.com/xpack/)
# Copyright (c) 2022 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/MIT/.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is anything but empty.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Identify the script location, to reach, for example, the helper scripts.

script_path="$0"
if [[ "${script_path}" != /* ]]
then
  # Make relative path absolute.
  script_path="$(pwd)/$0"
fi

script_name="$(basename "${script_path}")"

script_folder_path="$(dirname "${script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

if [ "$(uname)" == "Darwin" ]
then
  if [ ! -d "/Library/Developer/CommandLineTools/" ]
  then
    xcode-select --install
  fi
fi

if [ "${SHELL}" == "/bin/zsh" ]
then
  touch ~/.zshrc
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts node
nvm use node
nvm alias default node
nvm install-latest-npm
npm install --global xpm@latest

echo

echo "node: $(node --version)"
echo "npm: $(npm --version)"
echo "xpm: $(xpm --version)"

echo

echo "Done. Be sure to exit the current terminal and enter a new one."

# -----------------------------------------------------------------------------
