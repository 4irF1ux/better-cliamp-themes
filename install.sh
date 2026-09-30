#!/bin/sh
# extended-cliamp-themes installer (Linux/macOS).
# Usage: ./install.sh [--all] [--only name1,name2] [--list]
# Destination mirrors cliamp's config resolution:
#   CLIAMP_CONFIG_DIR > XDG_CONFIG_HOME/cliamp > ~/.config/cliamp
set -eu

SRC_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MODE="all"
ONLY=""

for arg in "$@"; do
  case "$arg" in
    --all) MODE="all" ;;
    --list) MODE="list" ;;
    --only=*) MODE="only"; ONLY="${arg#--only=}" ;;
    *) echo "unknown arg: $arg (use --all, --only=a,b or --list)" >&2; exit 1 ;;
  esac
done

if [ -n "${CLIAMP_CONFIG_DIR:-}" ]; then
  DEST="$CLIAMP_CONFIG_DIR/themes"
elif [ -n "${XDG_CONFIG_HOME:-}" ]; then
  DEST="$XDG_CONFIG_HOME/cliamp/themes"
elif [ -n "${HOME:-}" ]; then
  DEST="$HOME/.config/cliamp/themes"
else
  echo "error: set CLIAMP_CONFIG_DIR or HOME" >&2
  exit 1
fi

pick() {
  if [ "$MODE" = "all" ]; then
    ls "$SRC_DIR/themes"/*.toml
  else
    old_ifs="$IFS"; IFS=","
    # shellcheck disable=SC2162
    for n in $ONLY; do printf '%s/themes/%s.toml\n' "$SRC_DIR" "$n"; done
    IFS="$old_ifs"
  fi
}

if [ "$MODE" = "list" ]; then
  for f in "$SRC_DIR"/themes/*.toml; do basename "$f" .toml; done
  exit 0
fi

mkdir -p "$DEST"
for f in $(pick); do
  if [ ! -f "$f" ]; then echo "unknown theme file: $f" >&2; exit 1; fi
  cp "$f" "$DEST/"
  echo "installed: $(basename "$f" .toml) -> $DEST/"
done
