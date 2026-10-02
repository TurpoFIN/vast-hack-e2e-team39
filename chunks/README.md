# Chunks (base64 of vast-hack-e2e.tgz)

Split of the e2e tarball as base64 text chunks for GitHub upload size limits.

## Rebuild

```bash
bash rebuild.sh
# or:
for i in $(seq -w 0 24); do cat "chunk-$i.txt"; done | tr -d '\n' | base64 -d > vast-hack-e2e.tgz
```

Expected SHA256 of `vast-hack-e2e.tgz`:

`be9ab94dbea3ddd748d837a8a4b7afa79be2eb22075f2723456e041a479db169`

Chunks: `chunk-00.txt` … `chunk-24.txt` (25 files).
