#!/usr/bin/env bash
#
# Description: Bash completion file for kbh.
#    Homepage: https://github.com/krathalan/wtwitch
#
# Copyright (C) 2024 krathalan
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#######################################
# Sets the appropriate $COMPREPLY for the user's input.
# Globals:
#   COMP_WORDS
#   COMPREPLY
#   XDG_CONFIG_HOME
#   HOME
# Arguments:
#   none
# Returns:
#   none
#######################################
_kbh_completions()
{
  # COMP_WORDS[0] = kbh
  # COMP_WORDS[1] = subcmd (e.g. backup, list, info, etc.)
  # COMP_WORDS[2] = target repo
  # COMP_WORDS[3] = potential target archive

  if [[ "${#COMP_WORDS[@]}" -lt "3" ]]; then
    # Subcommand completion
    mapfile -t COMPREPLY <<< "$(compgen -W "help prune info init list mount backup status delete" "${COMP_WORDS[1]}")"
  elif [[ "${COMP_WORDS[1]}" == "prune" ]] || [[ "${COMP_WORDS[1]}" == "info" ]] || [[ "${COMP_WORDS[1]}" == "list" ]] || [[ "${COMP_WORDS[1]}" == "mount" ]] || [[ "${COMP_WORDS[1]}" == "backup" ]] || [[ "${COMP_WORDS[1]}" == "status" ]] || [[ "${COMP_WORDS[1]}" == "delete" ]]; then
    # Return list of configured repos
    mapfile -t COMPREPLY <<< "$(jaq -r ".repos[].name" "${XDG_CONFIG_HOME:-${HOME}/.config}/krathalan/kbh.json")"
  fi
}

complete -F _kbh_completions kbh
