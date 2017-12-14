#!/bin/bash

set -u
exe=${1:?First argument is the executable under test}

WHITE="$(tput setaf 9)"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
SUCCESSFULLY=0
WITH_FAILURE=1
IT_COUNT=0

function title () {
  echo "$WHITE-----------------------------------------------------"
  echo "$@"
  echo "-----------------------------------------------------"
}

function it () {
  IT_COUNT=$(( IT_COUNT + 1 ))
  echo 1>&2 -n "$GREEN" "$@"
}

function run () {
  local expected_exit_code=$1
  shift
  local output=
  output="$("$@" 2>&1)"
  
  if [[ $? == "$expected_exit_code" ]]; then
    echo 1>&2 "$GREEN" " - OK"
  else
    echo 1>&2 "$RED" " - FAIL"
    echo 1>&2 "$output"
    exit $IT_COUNT
  fi
}

title "'vault' subcommand"

it "defines a default for the vault configuration file" && \
  run $SUCCESSFULLY $exe vault
  
title "'yaml' subcommand"

it "needs a yaml file to be defined" && \
  run $WITH_FAILURE $exe yaml



