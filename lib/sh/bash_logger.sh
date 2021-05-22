#!/usr/bin/env bash

# Name: bash_logger.sh
#
# Description: General purpose library to print log4j
# style messages for logging at different levels:
# TRACE > DEBUG > INFO > WARN > ERROR > FATAL
#
# Usage: https://github.com/DushyanthJyothi/bash-logger/blob/master/README.md
#
# Author: Dushyanth Jyothi <djyothi@ebi.ac.uk>
#
# Copyright (c) 2017-2021 Dushyanth Jyothi
# Licensed under the GNU General Public License v3.0
#
# TODO(dushyanth): lots of repeat code (improve)
#
# Follow shellguide: https://google.github.io/styleguide/shellguide.html
# Check code against: https://www.shellcheck.net/


set -u
set -e

declare -gA __bl_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG [INFO]=INFO [WARN]=WARN [ERROR]=ERROR [FATAL]=FATAL)
declare -gA __bl_run_times

__log_level=
__bl_script_start_time=$(date +%s)
__bl_function_start_time=$(date +%s)
__bl_script_name=
__bl_function_name=
__bl_called_line_number=
__bl_log_message=
__bl_time_and_date=



function set_log_level() {
  if [ -z "$1" ]; then
    echo "No log level provided, setting to INFO log level"
    __log_level="INFO"
  else
    __log_level="$1"
    if [[ ! "${__bl_log_levels[${__log_level}]+isset}" ]]; then
      echo "Log level provided $1 is not avalid, setting to INFO log level"
      __log_level="INFO"
    fi
  fi
}



# Default log : INFO
function log() {

  __bl_script_name="${BASH_SOURCE[1]}"
  __bl_script_name="${__bl_script_name##*/}"

  __bl_function_name="${FUNCNAME[1]}"

  __bl_called_line_number="${BASH_LINENO[0]}"

  __bl_log_message="$*"

  __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
  echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message}"
}

# TRACE: designates finer-grained informational events than the DEBUG
function log_trace() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="TRACE"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_functions_length="${#FUNCNAME[@]}"

    #${FUNCNAME[$i]} was called from the file ${BASH_SOURCE[$i+1]} at line number ${BASH_LINENO[$i]}

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}"

    if (( ${#FUNCNAME[@]} > 2 )); then
      echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - Execution call stack:"
    fi

    for (( i=0; i < __bl_functions_length; i++ )); do
      if (( $i !=  $(( __bl_functions_length - 1 )) )); then
        if [[ "${BASH_SOURCE[$i]}" != *"bash_logger"* ]]; then
           echo "   ${BASH_SOURCE[$i+1]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)"
        fi
      else
        echo "    ${BASH_SOURCE[$i]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)"
      fi
    done
  fi
}


# DEBUG: designates fine-grained informational events that are most useful to debug an application.
function log_debug() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="DEBUG"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}"
  fi
}


# INFO: designates informational messages that highlight the progress of the application at coarse-grained level.
function log_info() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG [INFO]=INFO)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="INFO"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}"
  fi
}

# WARN: designates potentially harmful situations.
function log_warn() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG [INFO]=INFO [WARN]=WARN)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="WARN"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}"
  fi
}


# ERROR: designates error events that might still allow the application to continue running.
function log_error() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG [INFO]=INFO [WARN]=WARN [ERROR]=ERROR)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="ERROR"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}" >&2

    if (( ${#FUNCNAME[@]} > 2 )); then
      echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - Execution call stack:" >&2
    fi

    for (( i=0; i < __bl_functions_length; i++ )); do
      if (( $i !=  $(( __bl_functions_length - 1 )) )); then
        if [[ "${BASH_SOURCE[$i]}" != *"bash_logger"* ]]; then
           echo "   ${BASH_SOURCE[$i+1]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)" >&2
        fi
      else
        echo "    ${BASH_SOURCE[$i]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)" >&2
      fi
    done

  fi
}


# FATAL: designates very severe error events that will presumably lead the application to abort.
function log_fatal() {
  declare -A __bl_allowed_log_levels
  __bl_allowed_log_levels=([TRACE]=TRACE [DEBUG]=DEBUG [INFO]=INFO [WARN]=WARN [ERROR]=ERROR [FATAL]=FATAL)
  if [[ "${__bl_allowed_log_levels[${__log_level}]+isset}" ]]; then
    __bl_log_message_type="FATAL"

    __bl_script_name="${BASH_SOURCE[1]}"
    __bl_script_name="${__bl_script_name##*/}"

    __bl_function_name="${FUNCNAME[1]}"

    __bl_called_line_number="${BASH_LINENO[0]}"

    __bl_log_message="$*"

    __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
    echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - ${__bl_log_message}" >&2

    if (( ${#FUNCNAME[@]} > 2 )); then
      echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message_type} - Execution call stack:" >&2
    fi

    for (( i=0; i < __bl_functions_length; i++ )); do
      if (( $i !=  $(( __bl_functions_length - 1 )) )); then
        if [[ "${BASH_SOURCE[$i]}" != *"bash_logger"* ]]; then
           echo "   ${BASH_SOURCE[$i+1]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)" >&2
        fi
      else
        echo "    ${BASH_SOURCE[$i]//.\//}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(..)" >&2
      fi
    done

  fi
}

# info message to log start of something
function log_start() {
  __bl_function_start_time=$(date +%s)

  __bl_script_name="${BASH_SOURCE[1]}"
  __bl_script_name="${__bl_script_name##*/}"

  __bl_function_name="${FUNCNAME[1]}"

  __bl_called_line_number="${BASH_LINENO[0]}"

  __bl_run_times["${__bl_script_name}:${__bl_function_name}"]="$__bl_function_start_time"

   __bl_log_message="#-- STARTED ${__bl_function_name^^} --#"

  __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
  echo ""
  echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message}"
}

# info message to log end of something
function log_finish() {

  __bl_script_name="${BASH_SOURCE[1]}"
  __bl_script_name="${__bl_script_name##*/}"

  __bl_function_name="${FUNCNAME[1]}"

  __bl_called_line_number="${BASH_LINENO[0]}"

  __bl_log_message="|-- FINISHED ${__bl_function_name^^} --|"

  __bl_time_and_date="$(date '+%d-%m-%Y %H:%M:%S')"
  if [ "${__bl_function_name^^}" = "MAIN" ]; then
    run_time=$(( $(date +%s) - __bl_script_start_time ))
  else
    __bl_function_start_time=${__bl_run_times["${__bl_script_name}:${__bl_function_name}"]}
    run_time=$(( $(date +%s) - __bl_function_start_time ))
  fi
  __bl_log_message="|-- FINISHED ${__bl_function_name^^} - Took: $((run_time / 3600))h:$(( (run_time % 3600) / 60 ))m:$(( (run_time % 3600) % 60 ))s --|"

  echo "${__bl_time_and_date} - ${__bl_script_name}:${__bl_function_name}:${__bl_called_line_number} - ${__bl_log_message}"
  echo ""
}

