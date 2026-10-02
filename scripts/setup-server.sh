#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== Minecraft Paper + Geyser setup =="

if ! command -v java >/dev/null 2>&1; then
  echo "Java is not installed. Rebuild the Codespace using .devcontainer."
  exit 1
fi

JAVA_MAJOR="$(java -version 2>&1 | awk -F'[".]' '/version/ {print $2; exit}')"
echo "Java detected: $(java -version 2>&1 | head -n 1)"

if [[ -z "$JAVA_MAJOR" || "$JAVA_MAJOR" -lt 25 ]]; then
  echo "Paper 26.2+ requires Java 25+."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  echo "Installing required download tools..."
  sudo apt-get update
  sudo apt-get install -y curl jq
fi

mkdir -p plugins logs

USER_AGENT="minecraft-codespace/1.0 (https://github.com/tyeler964-web/minecraft-codespace)"

echo "Finding the latest stable Paper build..."
PAPER_VERSION="$(curl -fsSL -H "User-Agent: $USER_AGENT" "https://fill.papermc.io/v3/projects/paper" | jq -r '.versions | to_entries[0] | .value[0]')"

BUILDS_RESPONSE="$(curl -fsSL -H "User-Agent: $USER_AGENT" "https://fill.papermc.io/v3/projects/paper/versions/$PAPER_VERSION/builds")"
PAPER_BUILD="$(echo "$BUILDS_RESPONSE" | jq -r 'first(.[] | select(.channel == "STABLE") | .id)')"
PAPER_URL="$(echo "$BUILDS_RESPONSE" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url)')"

if [[ -z "$PAPER_VERSION" || "$PAPER_VERSION" == "null" || -z "$PAPER_BUILD" || "$PAPER_BUILD" == "null" || -z "$PAPER_URL" || "$PAPER_URL" == "null" ]]; then
  echo "Could not determine a stable Paper build."
  exit 1
fi

echo "Downloading Paper $PAPER_VERSION build $PAPER_BUILD..."
curl -fL -H "User-Agent: $USER_AGENT" "$PAPER_URL" -o server.jar

echo "Downloading latest Geyser-Spigot..."
curl -fL "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot" -o plugins/Geyser-Spigot.jar

echo "Downloading latest Floodgate-Spigot..."
curl -fL "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot" -o plugins/floodgate-spigot.jar

chmod +x scripts/*.sh
echo "Setup complete."
echo "Paper: $PAPER_VERSION build $PAPER_BUILD"
echo "eula.txt is still eula=false until you accept the Minecraft EULA."
