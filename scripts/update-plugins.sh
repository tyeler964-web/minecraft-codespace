#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

mkdir -p plugins

UA="minecraft-codespace/1.0 (https://github.com/tyeler964-web/minecraft-codespace)"

download_modrinth_latest() {
  local slug="$1"
  local output="$2"
  echo "Downloading $slug..."
  local json
  json="$(curl -fsSL -A "$UA" "https://api.modrinth.com/v2/project/$slug/version?loaders=[%22paper%22]&game_versions=[%2226.2%22]")"
  local url
  url="$(echo "$json" | jq -r 'first(.[] | select(.version_type == "release") | .files[] | select(.primary == true) | .url) // empty')"
  if [[ -z "$url" ]]; then
    echo "No Paper 26.2 release found for $slug."
    return 1
  fi
  curl -fL -A "$UA" "$url" -o "plugins/$output"
}

download_modrinth_version() {
  local slug="$1"
  local version_id="$2"
  local output="$3"
  echo "Downloading $slug $version_id..."
  local json
  json="$(curl -fsSL -A "$UA" "https://api.modrinth.com/v2/version/$version_id")"
  local url
  url="$(echo "$json" | jq -r 'first(.files[] | select(.primary == true) | .url) // empty')"
  if [[ -z "$url" ]]; then
    echo "Could not find the download file for $slug $version_id."
    return 1
  fi
  curl -fL -A "$UA" "$url" -o "plugins/$output"
}

echo "== Installing Tsuna server plugins =="

# Core/support plugins.
download_modrinth_latest "multiverse-core" "Multiverse-Core.jar"
download_modrinth_latest "multiverse-inventories" "Multiverse-Inventories.jar"
download_modrinth_latest "multiverse-nether-portals" "Multiverse-NetherPortals.jar"
download_modrinth_latest "multiverse-portals" "Multiverse-Portals.jar"
download_modrinth_latest "multiverse-signportals" "Multiverse-SignPortals.jar"
download_modrinth_latest "simplescore" "SimpleScore.jar"
download_modrinth_latest "viaversion" "ViaVersion.jar"
download_modrinth_latest "placeholderapi" "PlaceholderAPI.jar"
download_modrinth_latest "smartspawner" "SmartSpawner.jar"

# The current Donut Shards project has a Paper/26.2 release.
download_modrinth_version "donut-shards" "NaSbotYr" "DonutShards.jar"

# LifeSteal 3 is the exact plugin version previously used. Its published compatibility
# is for the 1.21.x line rather than Paper 26.2, so download it but do not force-load it.
download_modrinth_version "lifesteal-system" "YTZmGnfo" "LifeSteal.jar"

# MyCommand 5.7.5 is hosted on Bukkit/CurseForge rather than Modrinth.
echo "Downloading MyCommand 5.7.5..."
curl -fL -A "$UA" "https://dev.bukkit.org/projects/mycommand/files/6217154/download" -o plugins/MyCommand.jar

echo
echo "Plugin download complete."
echo
echo "Installed:"
ls -1 plugins/*.jar 2>/dev/null | sed 's#^# - #' || true
echo
echo "Note: MyCommand's custom economy GUI/config files are not bundled in the public JAR."
echo "Existing plugin configs are preserved if they already exist."
