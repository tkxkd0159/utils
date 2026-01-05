#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/tkxkd0159/utils/main"
INSTALL_DIR=""
REQUESTED_TOOLS=("$@")

if [[ ${#REQUESTED_TOOLS[@]} -eq 0 ]]; then
  echo "Error: No tools specified for installation" >&2
  echo "" >&2
  echo "Usage:" >&2
  echo "  curl -sSL https://raw.githubusercontent.com/tkxkd0159/utils/main/install.sh | bash -s TOOL..." >&2
  echo "" >&2
  echo "Examples:" >&2
  echo "  curl -sSL https://raw.githubusercontent.com/tkxkd0159/utils/main/install.sh | bash -s gw" >&2
  echo "  curl -sSL https://raw.githubusercontent.com/tkxkd0159/utils/main/install.sh | bash -s -- gw tool2" >&2
  echo "" >&2
  echo "Available tools: Check https://github.com/tkxkd0159/utils/tree/main/scripts" >&2
  exit 1
fi

echo "==> Installing tools: ${REQUESTED_TOOLS[*]}"

# Detect best installation directory
if [[ -w "/usr/local/bin" ]]; then
  INSTALL_DIR="/usr/local/bin"
  echo "    Installing to: $INSTALL_DIR (system-wide)"
elif [[ -d "$HOME/.local/bin" ]] || mkdir -p "$HOME/.local/bin" 2>/dev/null; then
  INSTALL_DIR="$HOME/.local/bin"
  echo "    Installing to: $INSTALL_DIR (user-local)"

  # Check if ~/.local/bin is in PATH
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "    Warning: $HOME/.local/bin is not in your PATH"
    echo "    Add this to your ~/.bashrc or ~/.zshrc:"
    echo "      export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
else
  echo "Error: Cannot find writable installation directory" >&2
  echo "Please run with sudo: curl -sSL ... | sudo bash" >&2
  exit 1
fi

# Download and install each requested tool
INSTALLED_SCRIPTS=()
for script in "${REQUESTED_TOOLS[@]}"; do
  echo "==> Installing $script..."
  SCRIPT_URL="$REPO_URL/scripts/$script"

  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$script" 2>/dev/null; then
      chmod +x "$INSTALL_DIR/$script"
      echo "    ✓ $script installed to $INSTALL_DIR/$script"
      INSTALLED_SCRIPTS+=("$script")
    else
      echo "    ✗ Failed to download $script"
    fi
  elif command -v wget >/dev/null 2>&1; then
    if wget -qO "$INSTALL_DIR/$script" "$SCRIPT_URL" 2>/dev/null; then
      chmod +x "$INSTALL_DIR/$script"
      echo "    ✓ $script installed to $INSTALL_DIR/$script"
      INSTALLED_SCRIPTS+=("$script")
    else
      echo "    ✗ Failed to download $script"
    fi
  fi
done

# Run post-installation setup for scripts that support it
echo ""
echo "==> Running post-installation setup..."

# gw: Shell integration
if [[ " ${INSTALLED_SCRIPTS[*]} " =~ " gw " ]]; then
  echo "==> Setting up gw shell integration..."
  if "$INSTALL_DIR/gw" install 2>&1; then
    echo "    ✓ gw shell integration configured"
  else
    echo "    ⚠ Shell integration setup failed (run 'gw install' manually later)"
  fi
fi

# Final summary
if [[ ${#INSTALLED_SCRIPTS[@]} -eq 0 ]]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✗ No tools were successfully installed"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Installation complete!"
echo ""
echo "Installed tools: ${INSTALLED_SCRIPTS[*]}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
