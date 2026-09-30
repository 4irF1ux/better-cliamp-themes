#!/bin/sh
# Remote one-liner installer (Linux/macOS, no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/4irF1ux/better-cliamp-themes/main/install-remote.sh | sh
# Optional env: BCT_ONLY="onedark,flexoki-dark" (default: all), BCT_REF="main"
set -eu
REPO="4irF1ux/better-cliamp-themes"
REF="${BCT_REF:-main}"

if [ -n "${CLIAMP_CONFIG_DIR:-}" ]; then DEST="$CLIAMP_CONFIG_DIR/themes"
elif [ -n "${XDG_CONFIG_HOME:-}" ]; then DEST="$XDG_CONFIG_HOME/cliamp/themes"
elif [ -n "${HOME:-}" ]; then DEST="$HOME/.config/cliamp/themes"
else echo "error: set CLIAMP_CONFIG_DIR or HOME" >&2; exit 1; fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM
curl -fsSL "https://github.com/$REPO/archive/refs/heads/$REF.tar.gz" -o "$TMP/repo.tar.gz"
tar -xzf "$TMP/repo.tar.gz" -C "$TMP"
SRC="$TMP/better-cliamp-themes-$REF/themes"

mkdir -p "$DEST"
if [ -n "${BCT_ONLY:-}" ]; then
  old_ifs="$IFS"; IFS=","
  for n in $BCT_ONLY; do cp "$SRC/$n.toml" "$DEST/" && echo "installed: $n -> $DEST/"; done
  IFS="$old_ifs"
else
  for f in "$SRC"/*.toml; do cp "$f" "$DEST/" && echo "installed: $(basename "$f" .toml) -> $DEST/"; done
fi
echo 'done. try: cliamp --start-theme "onedark"'
