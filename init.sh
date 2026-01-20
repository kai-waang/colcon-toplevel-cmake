#!/bin/bash

# Placeholder for installation path. 
# install.sh will replace this specific string with the actual path.
INSTALLED_DIR="__INSTALL_PATH_MARKER__"

# Fallback: if not installed (running locally), use the script's own directory
if [[ "$INSTALLED_DIR" == "__INSTALL_PATH_MARKER__" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
else
    SCRIPT_DIR="$INSTALLED_DIR"
fi

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -n|--name) NEW_NAME="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

TARGET_FILE="$(pwd)/CMakeLists.txt"

# Check if CMakeLists.txt already exists to prevent accidental overwrite
if [ -f "$TARGET_FILE" ]; then
    echo "Error: CMakeLists.txt already exists in the current directory."
    echo "Please remove it or run this script in a clean directory."
    exit 1
fi

# Check if the source template exists
TEMPLATE_FILE="$SCRIPT_DIR/toplevel.cmake"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file not found at $TEMPLATE_FILE"
    exit 1
fi

# Copy the template
cp "$TEMPLATE_FILE" "$TARGET_FILE"
echo "Workspace initialized: Created CMakeLists.txt from template."

# Update Project Name if provided
if [ -n "$NEW_NAME" ]; then
  # Use | delimiter to avoid issues with slashes in names, though unusual for project names
  sed -i "s/project(\"PROJECT_NAME\")/project(\"$NEW_NAME\")/g" "$TARGET_FILE"
  echo "Project name set to: $NEW_NAME"
else
  echo "No project name provided (use -n/--name to set it). Using default placeholder."
fi
