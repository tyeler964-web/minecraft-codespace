# Tsuna Minecraft Codespace Server

Paper Java server with Geyser + Floodgate for Java/Bedrock cross-play, designed for a GitHub Codespace.

## Included
- Paper server bootstrap script
- Java 25 Codespace configuration
- Geyser-Spigot for Bedrock-to-Java bridging
- Floodgate for Bedrock Microsoft-account authentication
- Playit agent launcher
- Start, stop, and plugin-update scripts
- Gitignore for generated server data

## First setup
1. Rebuild the Codespace so .devcontainer/devcontainer.json takes effect.
2. Run: bash scripts/setup-server.sh
3. Accept the Minecraft EULA, then set eula=false to eula=true.
4. Start Paper: bash scripts/start-server.sh
5. Let Paper and Geyser generate their configuration, then stop it with: bash scripts/stop-server.sh
6. Open a second terminal and run: bash scripts/start-playit.sh

Playit will provide a claim/setup step on first use. After the agent is claimed, create the required Minecraft Java TCP tunnel and Bedrock UDP tunnel in the Playit dashboard.

## Important
Do not commit playit.toml, playit.secret, Floodgate keys, worlds, or generated plugin configuration. They are intentionally ignored by Git.
