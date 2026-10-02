#!/usr/bin/env bash
# Healthcheck + dry-run wiring for VAST DataEngine / vastdb / S3.
# Safe with no credentials: prints plan, writes ledgers, exits 0 on dry-run.
# With venue creds: probes S3 + vastdb and (optionally) runs `vastde triggers create`.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
# shellcheck disable=SC1091
[[ -f .env ]] && set -a && source .env && set +a

PY="${ROOT}/.venv/bin/python"
export PYTHONPATH="$ROOT${PYTHONPATH:+:$PYTHONPATH}"
export STORE_BACKEND="${STORE_BACKEND:-vast}"

echo "=== wire_vast ==="
echo "STORE_BACKEND=$STORE_BACKEND"
echo "VAST_ENDPOINT=${VAST_ENDPOINT:-<unset>}"
echo "VAST_BUCKET=${VAST_BUCKET:-video-agents}  VAST_SCHEMA=${VAST_SCHEMA:-hack}"
echo "VAST_DRY_RUN=${VAST_DRY_RUN:-0}"
echo

"$PY" - <<'PY'
from __future__ import annotations
import json, os, sys
from shared.config import settings
from shared.store import VastDBStore, reset_store, get_store
from shared import dataengine as de

reset_store()
s = settings()
print("settings:", json.dumps({
    "store_backend": s.store_backend,
    "endpoint": s.vast_endpoint,
    "s3_endpoint": s.vast_s3_endpoint or s.vast_endpoint,
    "bucket": s.vast_bucket,
    "schema": s.vast_schema,
    "dry_run_flag": s.vast_dry_run,
    "has_access_key": bool(s.vast_access_key),
    "has_secret_key": bool(s.vast_secret_key),
}, indent=2))

# Force VastDBStore regardless of STORE_BACKEND so this script always exercises the path.
st = VastDBStore()
h = st.health()
print("store.health:", json.dumps(h, indent=2))

# Local write-through smoke (never claims remote success in dry-run)
import pandas as pd, numpy as np
n = st.write_table("_wire_smoke", pd.DataFrame({"x": [1, 2]}), part="wire")
st.put_object("_wire_smoke/hello.txt", b"ok")
st.upsert_vectors("_wire_smoke", ["a"], np.array([[1.0, 0.0]], np.float32))
print(f"local write-through: table_rows={n} objects={st.list_objects('_wire_smoke/')[:3]}")

plan = de.register_standing_trigger(apply=os.environ.get("WIRE_VAST_APPLY") == "1")
print("dataengine:", json.dumps({
    "applied": plan.get("applied"),
    "creds_ready": plan.get("creds_ready"),
    "vastde_installed": plan.get("vastde_installed"),
    "trigger": plan.get("trigger"),
    "ledger": plan.get("ledger"),
}, indent=2, default=str))
print("\n--- vastde commands (paste at venue) ---")
for c in plan.get("vastde_commands") or []:
    print(c)
    print("---")

if h["dry_run"]:
    print("\nRESULT: DRY-RUN only (no cluster writes claimed). Paste creds from VAST_WIRING.md and re-run.")
    sys.exit(0)

# Live probe
try:
    keys = st.list_objects("")[:5]
    tables = st.tables()[:10]
    print(f"\nLIVE OK: listed {len(keys)} object prefix sample, tables={tables}")
    sys.exit(0)
except Exception as e:
    print(f"\nLIVE PROBE FAILED: {type(e).__name__}: {e}", file=sys.stderr)
    sys.exit(2)
PY
