#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f server.jar ]]; then
  echo "server.jar is missing. Run: bash scripts/setup-server.sh"
  exit 1
fi

if ! grep -q '^eula=true$' eula.txt; then
  echo "eula.txt is not set to eula=true."
  echo "Accept the Minecraft EULA first, then run this command again."
  exit 1
fi

exec java -Xms1G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -jar server.jar --nogui
