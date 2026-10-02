#!/usr/bin/env bash
set -euo pipefail
echo "Starting the Playit agent."
echo "If this is the first run, Playit will show a claim/setup URL."
echo "Open that URL in your browser and claim the agent."
if command -v playit >/dev/null 2>&1; then
  exec playit
fi
if [[ -x "$HOME/.local/bin/playit" ]]; then
  exec "$HOME/.local/bin/playit"
fi
echo "The playit command was not found."
exit 1
