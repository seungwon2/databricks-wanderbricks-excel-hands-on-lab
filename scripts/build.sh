#!/usr/bin/env bash
# Copy shared assets into each language docs_dir, then build every language site.
set -euo pipefail
cd "$(dirname "$0")/.."
ZENSICAL="${ZENSICAL:-zensical}"
for cfg in zensical.*.toml; do
  lang="${cfg#zensical.}"; lang="${lang%.toml}"
  rm -rf "docs/$lang/assets"
  cp -R docs/assets "docs/$lang/assets"
  "$ZENSICAL" build -f "$cfg"
done
cp scripts/root-index.html site/index.html
