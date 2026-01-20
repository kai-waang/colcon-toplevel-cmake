#!/bin/bash

set -e # Exit on error

DEFAULT_INSTALL_DIR="/opt/ros/cmake"
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ANSI colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Colcon Toplevel CMake Installer ===${NC}"

# 1. Select Installation Directory
echo -e "Where would you like to install the project?"
echo -e "Default: [${GREEN}${DEFAULT_INSTALL_DIR}${NC}]"
read -r -p "Enter path (leave empty for default): " USER_INPUT_PATH

INSTALL_DIR=${USER_INPUT_PATH:-$DEFAULT_INSTALL_DIR}

# Expand tilde if present (simple expansion)
INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

# 2. Confirmation
echo -e "\nInstallation Configuration:"
echo -e "  Source Dir:  ${CURRENT_DIR}"
echo -e "  Install Dir: ${YELLOW}${INSTALL_DIR}${NC}"
echo ""
read -r -p "Proceed with installation? [y/N] " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
fi

# 3. Create Directory & Check Permissions
SUDO=""
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Warning: Target directory exists. Files may be overwritten.${NC}"
    if [ ! -w "$INSTALL_DIR" ]; then
         echo "Target directory is not writable. Checking for sudo permissions..."
         if sudo -v; then
             SUDO="sudo"
         else
             echo -e "${RED}Error: Sudo authentication failed.${NC}"
             exit 1
         fi
    fi
else
    echo "Creating directory: $INSTALL_DIR"
    if ! mkdir -p "$INSTALL_DIR" 2>/dev/null; then
        echo "Permission denied. Attempting with sudo..."
        if sudo -v; then
            SUDO="sudo"
            $SUDO mkdir -p "$INSTALL_DIR" || {
                echo -e "${RED}Error: Could not create directory even with sudo.${NC}"
                exit 1
            }
        else
             echo -e "${RED}Error: Sudo authentication failed.${NC}"
             exit 1
        fi
    fi
fi

# 4. Copy Files
echo "Copying files..."
$SUDO cp "$CURRENT_DIR/toplevel.cmake" "$INSTALL_DIR/"
$SUDO cp "$CURRENT_DIR/colcon.cmake" "$INSTALL_DIR/"
$SUDO cp "$CURRENT_DIR/init.sh" "$INSTALL_DIR/"

# 5. Modify Files (The "Magic" Step)

# Fix 1: Update init.sh to point to the install directory
# We look for the marker __INSTALL_PATH_MARKER__ and replace it with the actual path
$SUDO sed -i "s|__INSTALL_PATH_MARKER__|$INSTALL_DIR|g" "$INSTALL_DIR/init.sh"
echo "Updated init.sh with installation path."

# Fix 2: Update toplevel.cmake to include the installed colcon.cmake
# Currently it points to /opt/ros/scripts/cmake/colcon.cmake
# We will replace that line to point to ${INSTALL_DIR}/colcon.cmake
# Note: modifying the INSTALLED copy, not the source.
$SUDO sed -i "s|include(\"/opt/ros/scripts/cmake/colcon.cmake\")|include(\"$INSTALL_DIR/colcon.cmake\")|g" "$INSTALL_DIR/toplevel.cmake"
echo "Updated toplevel.cmake path references."

# 6. Set Permissions
$SUDO chmod +x "$INSTALL_DIR/init.sh"

echo -e "\n${GREEN}Installation Complete!${NC}"
echo "------------------------------------------------"
echo "You can now use the tool by running:"
echo "  $INSTALL_DIR/init.sh"
echo ""
echo "Tip: Add the following to your ~/.bashrc or ~/.zshrc to use it easily:"
echo "  alias colcon-init='$INSTALL_DIR/init.sh'"
echo "------------------------------------------------"
