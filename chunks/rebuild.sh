#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
for i in $(seq -w 0 246); do cat "chunk-$i.txt"; done | tr -d '\n' | base64 -d > vast-hack-e2e.tgz
echo OK $(wc -c < vast-hack-e2e.tgz) bytes
sha256sum vast-hack-e2e.tgz
