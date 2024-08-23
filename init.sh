#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -n|--name) NEW_NAME="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

if [ ! -f "$(pwd)/a.txt" ]; then
  cp "$SCRIPT_DIR/toplevel.cmake" "$(pwd)/CMakeLists.txt"
  echo "Workspace initialized with toplevel CMakeLists.txt"
else
  echo "No toplevel.cmake found"
fi


if [ -n "$NEW_NAME" ]; then
  sed -i "s/PROJECT_NAME/$NEW_NAME/g" "$(pwd)/CMakeLists.txt"
  echo "Program's name set to : $NEW_NAME"
else
  echo "No project name provided"
fi

