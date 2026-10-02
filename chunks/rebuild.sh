#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
cat chunk-*.txt | tr -d '\n' | base64 -d > vast-hack-e2e.tgz
echo OK $(wc -c < vast-hack-e2e.tgz) bytes
sha256sum vast-hack-e2e.tgz
