#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="../.."
OUT="$ROOT_DIR/mac/Brewfile"

mkdir -p "$ROOT_DIR/mac"

echo 'tap "homebrew/bundle"' > "$OUT"

# --- TAPS
if command -v brew >/dev/null 2>&1; then
  brew tap | sort -u | while read -r tap; do
    # homebrew/core a homebrew/cask zapisovat nemusíme, ale nevadí to
    echo "tap \"$tap\"" >> "$OUT"
  done
fi

echo >> "$OUT"

# --- FORMULAE (jen leaves = bez závislostí)
if command -v brew >/dev/null 2>&1; then
  echo "# Formulae (top-level leaves)" >> "$OUT"
  brew leaves | sort -u | while read -r f; do
    echo "brew \"$f\"" >> "$OUT"
  done
fi

echo >> "$OUT"

# --- CASKS
if command -v brew >/dev/null 2>&1; then
  echo "# Casks" >> "$OUT"
  brew list --cask -1 2>/dev/null | sort -u | while read -r c; do
    echo "cask \"$c\"" >> "$OUT"
  done
fi

echo >> "$OUT"

# --- MAS (pokud je k dispozici)
if command -v mas >/dev/null 2>&1; then
  echo "# Mac App Store apps" >> "$OUT"
  # mas list -> "123456789 App Name (1.2.3)"
  mas list | while read -r line; do
    id="$(awk '{print $1}' <<< "$line")"
    # název: vše kromě prvního slova a závorky s verzí
    name="$(sed -E 's/^[0-9]+ (.+) \([^)]+\)$/\1/' <<< "$line")"
    # Ošetření uvozovek v názvu
    name_escaped="${name//\"/\\\"}"
    echo "mas \"$name_escaped\", id: $id" >> "$OUT"
  done
fi

echo
echo "Generated $OUT ✅"