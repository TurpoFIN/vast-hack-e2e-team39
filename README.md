# vast-hack-e2e-team39 (temporary transfer)

Minimal **Team 39** workshop transfer of `/workspace/vast-hack` — **no `.env` secrets**.

Local tarball on the build box: `/workspace/vast-hack-e2e.tgz` (**362 KB**).

## What is already public on this repo

| File | URL |
|------|-----|
| S3 smoke (paste-friendly) | https://raw.githubusercontent.com/TurpoFIN/vast-hack-e2e-team39/main/vast-wire-smoke.py |
| Repo home | https://github.com/TurpoFIN/vast-hack-e2e-team39 |

Anonymous file hosts were not used (blocked). The binary tarball stays on the box; VM cannot reach a box http.server.

## Transfer plan (VM)

### A — Preferred: browser download of smoke + code-server upload of tarball
1. On the VM browser open the smoke raw URL above → Save As `vast-wire-smoke.py`.
2. Via code-server file upload on the VM, upload `/workspace/vast-hack-e2e.tgz`.
3. On the VM:
```bash
tar -xzf vast-hack-e2e.tgz && cd vast-hack
set -a && source /config/team-39.config && set +a
python3 ../vast-wire-smoke.py
```

### B — Fallback: paste / curl smoke only
```bash
curl -fsSL -o vast-wire-smoke.py \
  https://raw.githubusercontent.com/TurpoFIN/vast-hack-e2e-team39/main/vast-wire-smoke.py
set -a && source /config/team-39.config && set +a
python3 vast-wire-smoke.py
```

### C — code-server upload only
Drag `vast-hack-e2e.tgz` into the VM workspace, then extract as in A.

**Do not** copy box `.env`. Workshop `/config/team-39.config` supplies credentials.

## Bundle exclusions

`.env`, `.venv`, `models/`, raw videos, `__pycache__`, `.git`, large docs images, evidence clips/pdf.

Delete this repo after the hackathon.
