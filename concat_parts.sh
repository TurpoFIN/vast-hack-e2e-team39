#!/usr/bin/env bash
set -euo pipefail
cat vast-hack-e2e.tgz.b64.part?? > vast-hack-e2e.tgz.b64
base64 -d vast-hack-e2e.tgz.b64 > vast-hack-e2e.tgz
ls -lh vast-hack-e2e.tgz
tar -tzf vast-hack-e2e.tgz | head
