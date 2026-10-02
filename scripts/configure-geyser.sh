#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

CONFIG="plugins/Geyser-Spigot/config.yml"

if [[ ! -f "$CONFIG" ]]; then
  echo "Geyser config does not exist yet."
  echo "Start Paper once, wait for it to finish loading, stop it, then run this script."
  exit 1
fi

python3 - "$CONFIG" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
s = s.replace("auth-type: online", "auth-type: floodgate")
s = s.replace("auth-type: offline", "auth-type: floodgate")
s = s.replace("port: 19132", "port: 19132", 1)
p.write_text(s)
PY

echo "Geyser configured for Floodgate authentication and Bedrock port 19132."
echo "Restart Paper after this change."
