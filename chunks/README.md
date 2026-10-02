mkdir -p /tmp/e2e && cd /tmp/e2e
for i in 00 01 02 03 04 05 06; do curl -fsSL -o chunk-$i.txt https://raw.githubusercontent.com/TurpoFIN/vast-hack-e2e-team39/main/chunks/chunk-$i.txt; done
curl -fsSL -o rebuild.sh https://raw.githubusercontent.com/TurpoFIN/vast-hack-e2e-team39/main/chunks/rebuild.sh
bash rebuild.sh
