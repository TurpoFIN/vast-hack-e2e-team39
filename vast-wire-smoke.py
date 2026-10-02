#!/usr/bin/env python3
"""Team 39 VAST S3 put/get smoke — no secrets in this file.

Reads credentials from the environment after the workshop config is sourced, e.g.:

  set -a && source /config/team-39.config && set +a
  python3 /path/to/vast-wire-smoke.py

Recognized env (first match wins for each role):
  endpoint: VAST_S3_ENDPOINT | VAST_ENDPOINT | AWS_ENDPOINT_URL | S3_ENDPOINT
  access:   VAST_ACCESS_KEY | AWS_ACCESS_KEY_ID
  secret:   VAST_SECRET_KEY | AWS_SECRET_ACCESS_KEY
  bucket:   VAST_BUCKET | S3_BUCKET  (default: team-39-vss-db)

Never prints secret values. TLS verify follows VAST_SSL_VERIFY (default 0 on
workshop VMs where the builder cert chain often fails; set to 1 to enforce).
"""
from __future__ import annotations

import os
import sys
import uuid

BUCKET_DEFAULT = "team-39-vss-db"
KEY = "_wire_smoke/hello.txt"
BODY = b"ok"


def _first(*names: str) -> str | None:
    for n in names:
        v = os.environ.get(n)
        if v not in (None, ""):
            return v
    return None


def main() -> int:
    endpoint = _first(
        "VAST_S3_ENDPOINT", "VAST_ENDPOINT", "AWS_ENDPOINT_URL", "S3_ENDPOINT"
    )
    access = _first("VAST_ACCESS_KEY", "AWS_ACCESS_KEY_ID")
    secret = _first("VAST_SECRET_KEY", "AWS_SECRET_ACCESS_KEY")
    bucket = _first("VAST_BUCKET", "S3_BUCKET") or BUCKET_DEFAULT
    verify_raw = (_first("VAST_SSL_VERIFY", "S3_SSL_VERIFY") or "0").lower()
    verify = verify_raw not in ("0", "false", "no", "off")

    missing = [n for n, v in (
        ("endpoint (VAST_S3_ENDPOINT|VAST_ENDPOINT|AWS_ENDPOINT_URL|S3_ENDPOINT)", endpoint),
        ("access (VAST_ACCESS_KEY|AWS_ACCESS_KEY_ID)", access),
        ("secret (VAST_SECRET_KEY|AWS_SECRET_ACCESS_KEY)", secret),
    ) if not v]
    if missing:
        print("FAIL: missing env:", "; ".join(missing), file=sys.stderr)
        print("Hint: set -a && source /config/team-39.config && set +a", file=sys.stderr)
        return 2

    try:
        import boto3
        from botocore.config import Config
    except ImportError:
        print("FAIL: boto3 not installed (pip install boto3)", file=sys.stderr)
        return 2

    # Unique suffix so parallel smokes do not race; still under _wire_smoke/
    key = f"{KEY}.{uuid.uuid4().hex[:8]}"
    print(f"endpoint={endpoint}")
    print(f"bucket={bucket} key={key} verify={verify} access_set={bool(access)} secret_set={bool(secret)}")

    client = boto3.client(
        "s3",
        endpoint_url=endpoint,
        aws_access_key_id=access,
        aws_secret_access_key=secret,
        config=Config(signature_version="s3v4"),
        verify=verify,
    )
    try:
        client.put_object(Bucket=bucket, Key=key, Body=BODY)
        obj = client.get_object(Bucket=bucket, Key=key)
        got = obj["Body"].read()
    except Exception as e:
        print(f"FAIL: {type(e).__name__}: {e}", file=sys.stderr)
        return 1

    if got != BODY:
        print(f"FAIL: body mismatch got={got!r} expected={BODY!r}", file=sys.stderr)
        return 1

    print(f"SUCCESS: put+get {bucket}/{key} body={BODY!r}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
