# vast-hack-e2e-team39 (temporary transfer)

Minimal **Team 39** workshop transfer of `/workspace/vast-hack` — **no `.env` secrets**.

Tarball size: **~362 KB** (`vast-hack-e2e.tgz`).

## Artifacts

| File | Purpose |
|------|---------|
| `vast-hack-e2e.tgz.b64.part00` … `part02` | Base64 of the e2e tarball (split for upload) |
| [`concat_parts.sh`](./concat_parts.sh) | Concat parts → decode → `vast-hack-e2e.tgz` |
| [`vast-wire-smoke.py`](./vast-wire-smoke.py) | S3 put/get smoke for `team-39-vss-db` (reads `/config` env) |
| [`decode_tarball.sh`](./decode_tarball.sh) | Decode a single `.b64` if you already concatenated |

**Raw smoke (paste fallback):**  
https://raw.githubusercontent.com/TurpoFIN/vast-hack-e2e-team39/main/vast-wire-smoke.py

## On the workshop VM (browser download)

1. Open https://github.com/TurpoFIN/vast-hack-e2e-team39 in the VM browser.
2. Download `vast-hack-e2e.tgz.b64.part00`, `part01`, `part02`, and `concat_parts.sh` (or clone the repo).
3. Rebuild and extract:

```bash
bash concat_parts.sh
tar -xzf vast-hack-e2e.tgz
cd vast-hack
```

4. **Do not** copy box `.env`. Source workshop config, then smoke:

```bash
set -a && source /config/team-39.config && set +a
python3 vast-wire-smoke.py   # or curl the raw URL above into a file
```

## Fallbacks

- **Paste smoke only:** open the raw URL above, paste into the VM editor, run after sourcing `/config/team-39.config`.
- **code-server upload:** upload `/workspace/vast-hack-e2e.tgz` from a machine that has it, or upload the three `.b64.part*` files + `concat_parts.sh`.
- Box `python -m http.server` will **not** reach the VM (no route to the box).

## Exclusions

`.env`, `.venv`, `models/`, raw videos, `__pycache__`, `.git`, large docs images, evidence clips/pdf.

Delete this repo after the hackathon.
