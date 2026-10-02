#!/usr/bin/env bash
set -euo pipefail
if pgrep -f 'java .*server\.jar' >/dev/null 2>&1; then
  pkill -SIGINT -f 'java .*server\.jar' || true
  echo "Stop signal sent to Paper."
else
  echo "No server.jar Java process was found."
fi
