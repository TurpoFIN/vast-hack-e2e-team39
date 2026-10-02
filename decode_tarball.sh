#!/usr/bin/env bash
# Decode vast-hack-e2e.tgz.b64 -> vast-hack-e2e.tgz (no network).
set -euo pipefail
SRC="${1:-vast-hack-e2e.tgz.b64}"
DST="${2:-vast-hack-e2e.tgz}"
base64 -d "$SRC" > "$DST"
ls -lh "$DST"
tar -tzf "$DST" | head -20
echo "OK: extract with: tar -xzf $DST"
