#!/usr/bin/env bash
set -euo pipefail

# Zjisti adresář, kde leží tento skript (funguje i přes symlinky)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT="$ROOT_DIR/mac/Brewfile"

# Kontrola, zda je brew nainstalovaný
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Error: Homebrew is not installed" >&2
    exit 1
fi

# Vytvoř adresář, pokud neexistuje
mkdir -p "$ROOT_DIR/mac"

# Inicializuj soubor
echo 'tap "homebrew/bundle"' > "$OUT"

# --- TAPS ---
echo "Collecting taps..."
brew tap | sort -u | while read -r tap; do
    echo "tap \"$tap\"" >> "$OUT"
done
echo >> "$OUT"

# --- FORMULAE (jen leaves = bez závislostí) ---
echo "Collecting formulae..."
echo "# Formulae (top-level leaves)" >> "$OUT"
brew leaves | sort -u | while read -r f; do
    echo "brew \"$f\"" >> "$OUT"
done
echo >> "$OUT"

# --- CASKS ---
echo "Collecting casks..."
echo "# Casks" >> "$OUT"
if brew list --cask -1 2>/dev/null | sort -u | while read -r c; do
    echo "cask \"$c\"" >> "$OUT"
done; then
    :
else
    echo "# No casks installed" >> "$OUT"
fi
echo >> "$OUT"

# --- MAS (pokud je k dispozici) ---
if command -v mas >/dev/null 2>&1; then
    echo "Collecting Mac App Store apps..."
    echo "# Mac App Store apps" >> "$OUT"
    mas list | while IFS= read -r line; do
        # Bezpečnější parsování: ID je první slovo
        id="$(echo "$line" | awk '{print $1}')"
        # Název: vše mezi ID a poslední závorkou
        name="$(echo "$line" | sed -E "s/^[0-9]+ (.+) \([^)]+\)$/\1/")"
        # Escape uvozovky a backslashe
        name="${name//\\/\\\\}"
        name="${name//\"/\\\"}"
        echo "mas \"$name\", id: $id" >> "$OUT"
    done
else
    echo "# mas-cli not installed - skipping Mac App Store apps" >> "$OUT"
fi

echo
echo "✅ Generated $OUT"