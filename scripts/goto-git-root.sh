#!/bin/bash

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ $? -eq 0 ]; then
  cd "$GIT_ROOT" || exit
  echo "moving to: $GIT_ROOT"
else
  echo "error detecting root directory"
  exit 1
fi