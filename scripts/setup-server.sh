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
  echo "Paper 26.2+ requires Java 25+. Rebuild the Codespace with the included devcontainer."
  exit 1
fi

mkdir -p plugins logs

echo "Finding the latest stable Paper build..."
PAPER_VERSION="$(curl -fsSL https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')"
PAPER_BUILD="$(curl -fsSL "https://api.papermc.io/v2/projects/paper/versions/$PAPER_VERSION/builds" | jq -r '[.builds[] | select(.channel=="default" and .downloads.application.name != null)] | last | .build')"

if [[ -z "$PAPER_VERSION" || "$PAPER_VERSION" == "null" || -z "$PAPER_BUILD" || "$PAPER_BUILD" == "null" ]]; then
  echo "Could not determine the latest Paper build."
  exit 1
fi

PAPER_URL="https://api.papermc.io/v2/projects/paper/versions/$PAPER_VERSION/builds/$PAPER_BUILD/downloads/paper-$PAPER_VERSION-$PAPER_BUILD.jar"

echo "Downloading Paper $PAPER_VERSION build $PAPER_BUILD..."
curl -fL "$PAPER_URL" -o server.jar

echo "Downloading latest Geyser-Spigot..."
curl -fL "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot" -o plugins/Geyser-Spigot.jar

echo "Downloading latest Floodgate-Spigot..."
curl -fL "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot" -o plugins/floodgate-spigot.jar

chmod +x scripts/*.sh
echo "Setup complete."
echo "Paper: $PAPER_VERSION build $PAPER_BUILD"
echo "eula.txt is still eula=false until you accept the Minecraft EULA."
