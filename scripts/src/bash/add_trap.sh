#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: © Vegard IT GmbH (https://vegardit.com)
# SPDX-FileContributor: Sebastian Thomschke
# SPDX-License-Identifier: Apache-2.0
# SPDX-ArtifactOfProjectHomePage: https://github.com/vegardit/docker-shared

# add_trap - append a command to a signal trap without overwriting it
#
# Usage: add_trap "command" [SIGNAL]
#   command - string to evaluate when SIGNAL triggers
#   SIGNAL  - name or number (default: EXIT)
#
# Examples:
#   add_trap 'echo goodbye'      # appends to EXIT
#   add_trap 'echo SIGINT!' INT
#
# Skips duplicate registrations for the same command+signal combo.
function add_trap() {
  local cmd=$1
  local sig=${2:-EXIT}

  local sig_name
  {
    if [[ $sig =~ ^[0-9]+$ ]]; then
      sig_name=$(kill -l "$sig")
    else
      sig_name=${sig^^}
      kill -l "$sig_name" &>/dev/null
    fi
  } || {
    log ERROR "add_trap: invalid signal '$sig'"
    return 1
  }

  # Compute effective trap list for current (sub)shell
  # Based on info from https://stackoverflow.com/a/59307894/5116073
  local old
  if [[ "${BASH_VERSINFO:-0}" -ge 4 ]]; then
    trap -- KILL &>/dev/null || true
    old=$(trap -p "$sig_name")
  else
    old=$( (trap -p "$sig_name") )
  fi
  old=${old#*\'}         # remove leading "trap -- '"
  old=${old%\'*}         # remove trailing "' EXIT"
  old=${old//"'\''"/"'"} # unescape every '\'' to '

  # if already present, do nothing
  if [[ ";$old;" == *";$cmd;"* ]]; then
    return 0
  fi

  # build the new combined handler
  if [[ -n $old ]]; then
    combined="$old;$cmd"
  else
    combined="$cmd"
  fi

  # check if debugging requested *and* xtrace wasn't already on
  if [[ ${ADD_TRAP_DEBUG:-} =~ ^(1|true)$ && $- != *x* ]]; then
    set -x
    trap -- "$combined" "$sig"
    set +x
  else
    trap -- "$combined" "$sig"
  fi
}
